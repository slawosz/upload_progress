require 'spec_helper'

class BaseConnection
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def receive_data(data)
    :ok
  end
  
end

class FakeProgressDataManager
  def initialize(arg)
  end
  
  def save(arg)
  end
end

class FooConnection < BaseConnection
  include UploadProgress::Handlers::Thin
end

describe UploadProgress::Handlers::Thin do

  before do
#    stub_const("UploadProgress::ProgressDataManager", FakeProgressDataManager)
  end
  
  subject do
    FooConnection.new(@request)
  end

  it 'should call #receive_data from super' do
    stub_const("UploadProgress::ProgressDataManager", FakeProgressDataManager)
    
    parsed_headers
    
    subject.receive_data('foo').should == :ok
  end
  
  describe 'when headers are available' do
    
    before { parsed_headers }

    context do
      
      before { stub_const("UploadProgress::ProgressDataManager", FakeProgressDataManager) }
      
      it 'should update progress' do
        subject.receive_data('foo')

        subject.instance_eval { @progress }.should == 3
      end

      
      it 'should summarize reciving data' do
        3.times { subject.receive_data('foo') }

        subject.instance_eval { @uploaded }.should == 9
      end

      it 'should get uid from request' do
        subject.receive_data('foo')
        subject.instance_eval { @uid }.should == @request.env['X-UploadId']
      end
    end
    

    it 'should save actual progress' do
      manager = double
      UploadProgress::ProgressDataManager.should_receive(:new).with(@request.env['X-UploadId']) do
        manager
      end
      manager.should_receive(:save).with(3)

      subject.receive_data('foo')      
    end

  end

  describe 'when headers are not available yet' do

    before do
      unparsed_headers
      stub_const("UploadProgress::ProgressDataManager", FakeProgressDataManager)
    end
    
    it 'should not calculate progress' do
      subject.receive_data('foo')

      subject.instance_eval { @progress }.should == nil
    end

    it 'should not get uid' do
      subject.receive_data('foo')
      subject.instance_eval { @uid }.should == nil
    end

  end

  def parsed_headers
    env = {'X-UploadId' => 123}
    @request = double(content_length: 100, env: env)
  end
  
  def unparsed_headers
    env = {}
    @request = double(content_length: 0, env: env)
  end

end
