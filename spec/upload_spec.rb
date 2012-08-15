require 'spec_helper'

describe UploadProgress::Upload do

  before do
    require 'pry'
    @env = {'rack.input' => StringIO.new(rack_input), 'CONTENT_TYPE' => content_type, 'CONTENT_LENGTH' => 551}
    @body_path = UploadProgress::ROOT_PATH + '/spec/fixtures/upload.html'
    stub_const("UploadProgress::FILES_PATH", UploadProgress::ROOT_PATH + '/spec/fixtures/uploads')
  end

  after { FileUtils.rm_r(Dir.glob(UploadProgress::ROOT_PATH + '/spec/fixtures/uploads/*')) }
  
  subject { UploadProgress::Upload.new(@body_path) }
  
  it 'should return valid response' do
    status = 200
    headers = {}
    body = "<html><span class='path'>#{UploadProgress::FILES_PATH}/1/fixture.txt</span></html>\n"

    subject.call(@env).should == [status, headers, body]
  end

  it 'should create directory for files properly' do
    3.times { subject.call(@env) }
    `ls #{UploadProgress::FILES_PATH}`.split("\n").sort.should == %w(1 2 3)
  end

  def rack_input
    "-----------------------------150047573721210644961878570988\r\nContent-Disposition: form-data; name=\"files\"; filename=\"fixture.txt\"\r\nContent-Type: text/plain\r\n\r\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\nThis is example file\n\r\n-----------------------------150047573721210644961878570988\r\nContent-Disposition: form-data; name=\"uploadid\"\r\n\r\n666\r\n-----------------------------150047573721210644961878570988--\r\n"
  end
  
  def content_type
    "multipart/form-data; boundary=---------------------------150047573721210644961878570988"
  end
  
end
