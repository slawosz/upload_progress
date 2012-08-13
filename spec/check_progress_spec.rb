require 'spec_helper'

describe UploadProgress::CheckProgress do

  before { @env = {'QUERY_STRING' => 'uid=666'} }
  
  subject { UploadProgress::CheckProgress.new }
  
  it 'should return progress in header' do
    manager = double
    UploadProgress::ProgressDataManager.should_receive(:new).with(666) do
      manager
    end
    manager.should_receive(:get) { 25 }
    
    subject.call(@env).should == [200, {'X-Progress' => 25}, nil]
  end
end
