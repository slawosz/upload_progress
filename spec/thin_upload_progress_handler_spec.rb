require 'spec_helper'
class FakeRequest
  attr_reader :env
  attr_reader :content_length

  def initialize(env, length)
    @env = env
    @content_length = length
  end
  
end

class BaseConnection
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def receive_data(data)
    :ok
  end
  
end

class FooConnection < BaseConnection
  include UploadProgress::Handlers::Thin
end

describe UploadProgress::Handlers::Thin do

  let(:uid) { '666' }
  let(:env) { {'QUERY_STRING' => "uid=#{uid}"} }
  let(:content_length) { 100 }
  let(:request) { FakeRequest.new(env, content_length) }
    
  subject do
    FooConnection.new(request)
  end

  it 'should call #receive_data from super' do
    stub_const("UploadProgress::ProgressDataStore", FakeStore)
    
    subject.receive_data('foo').should == :ok
  end

  describe 'when headers are available' do
    
    context do
      
      before { stub_const("UploadProgress::ProgressDataStore", FakeStore) }
      
      it 'should update progress' do
        subject.receive_data('foo') # foo.length == 3

        subject.instance_eval { @progress }.should == 3
      end
  
      it 'should summarize reciving data' do
        3.times { subject.receive_data('foo') }

        subject.instance_eval { @uploaded }.should == 9
      end

      it 'should get uid from request' do
        subject.receive_data('foo')
        subject.instance_eval { @uid }.should == uid
      end
    end
    

    it 'should save actual progress' do
      store = double
      UploadProgress::ProgressDataStore.should_receive(:new).with(uid) do
        store
      end
      store.should_receive(:save).with(3)

      subject.receive_data('foo')      
    end

  end

  describe 'when headers are not available yet' do

    let(:env) { Hash.new }
    let(:content_length) { 0 }
    
    before do
      stub_const("UploadProgress::ProgressDataStore", FakeStore)
    end
    
    it 'should not calculate progress' do
      subject.receive_data('foo')

      subject.instance_eval { @progress }.should == nil
    end

    it 'should not get uid' do
      subject.receive_data('foo')
      subject.instance_eval { @uid }.should == nil
    end

    it 'should not attempt to save progress' do
      subject.receive_data('foo')
      subject.instance_eval { @progress_data_store }.should == nil
    end
    
  end

end
