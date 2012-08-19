require 'spec_helper'

describe UploadProgress::Upload do

  before do
    @env = {'rack.input' => StringIO.new(rack_input), 'CONTENT_TYPE' => content_type, 'CONTENT_LENGTH' => 551, 'X-UploadId' => '666'}
    @spec_uploads_path = '/spec/fixtures/uploads'
    @spec_public_uploads_path = '/uploads'
    stub_const("UploadProgress::UPLOADS_PATH", @spec_uploads_path)
    stub_const("UploadProgress::PUBLIC_UPLOADS_PATH", @spec_public_uploads_path)
  end

  after { FileUtils.rm_r(Dir.glob(UploadProgress::ROOT_PATH + @spec_uploads_path + '/*')) }
  
  subject { UploadProgress::Upload.new }
  
  it 'should return valid response' do
    set_data_expectations_and_mocks
    
    status = 200
    headers = {}
    body = 'body'

    subject.call(@env).should == [status, headers, body]
  end
  
  it 'should create directory for files properly' do
    stub_const('UploadProgress::DescriptionManager', FakeManager)
    stub_const('UploadProgress::UploadedPresenter', FakeUploadedPresenter)
    
    names = %w( 123 231 312 )
    names.each { |name| subject.call(@env.merge('X-UploadId' => name)) }
    `ls #{UploadProgress::ROOT_PATH}#{@spec_uploads_path}`.split("\n").sort.should == names
  end

  def rack_input
    "-----------------------------150047573721210644961878570988\r\nContent-Disposition: form-data; name=\"files\"; filename=\"fixture.txt\"\r\nContent-Type: text/plain\r\n\r\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\n\r\n-----------------------------150047573721210644961878570988\r\nContent-Disposition: form-data; name=\"uploadid\"\r\n\r\n666\r\n-----------------------------150047573721210644961878570988--\r\n"
  end
  
  def content_type
    "multipart/form-data; boundary=---------------------------150047573721210644961878570988"
  end

  def set_data_expectations_and_mocks
    manager = double
    description = double
    UploadProgress::DescriptionManager.should_receive(:new) { manager }
    manager.should_receive(:get) { description }

    up = double
    UploadProgress::UploadedPresenter.should_receive(:new).with(UploadProgress::PUBLIC_UPLOADS_PATH + '/666/fixture.txt', description) { up }
    up.should_receive(:body) { 'body' }
  end

  class FakeUploadedPresenter
    def initialize(*); end
    def body; end
  end
  
end
