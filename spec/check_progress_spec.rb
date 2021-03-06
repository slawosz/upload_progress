require 'spec_helper'

describe UploadProgress::CheckProgress do

  before { @env = {'X-UploadId' => '666'} }
  
  subject { UploadProgress::CheckProgress.new }
  
  it 'should return progress in header' do
    store = double
    UploadProgress::ProgressDataStore.should_receive(:new).with('666') do
      store
    end
    store.should_receive(:get) { 25 }
    
    subject.call(@env).should == [200, {'Date' => Time.now.to_s, 'Content-Length' => '2', 'Content-Type' => 'text/html'}, '25']
  end
end
