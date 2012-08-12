require 'spec_helper'

class BaseConnection
  attr_reader :request, :env

  def initialize(request, env)
    @request, @env = request, env
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

  subject do
    FooConnection.new(@request, @env)
  end

  it 'should call #receive_data from super' do
    parsed_headers
    
    stub_const("UploadProgress::ProgressDataManager", FakeProgressDataManager)

    subject.receive_data('foo').should == :ok
  end
  
  describe 'when headers are available' do
    
    before { parsed_headers }
    
    it 'should update progress' do
      manager = double('manager')
      UploadProgress::ProgressDataManager.should_receive(:new).with(@env['X-UploadId']) { manager }
      manager.should_receive(:save)
      UploadProgress::UploadCalculator.any_instance.should_receive(:calculate).with(3, 100)

      subject.receive_data('foo')
    end

    
    it 'should summarize reciving data' do
      stub_const("UploadProgress::ProgressDataManager", FakeProgressDataManager)

      3.times { subject.receive_data('foo') }

      subject.instance_eval { @uploaded }.should == 9
    end


  end

  describe 'when headers are not available yet' do

    before { unparsed_headers }
    
    it 'should not calculate progress' do
      UploadProgress::UploadCalculator.should_not_receive(:new)

      subject.receive_data('foo')
    end
  end

  def parsed_headers
    @env = {'X-UploadId' => 123}
    @request = double(content_length: 100)
  end
  
  def unparsed_headers
    @env = {}
    @request = double(content_length: 0)
  end

end
