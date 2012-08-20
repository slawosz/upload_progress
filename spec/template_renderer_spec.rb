require 'spec_helper'

describe UploadProgress::TemplateRenderer do

  let(:body_path) { UploadProgress::ROOT_PATH + '/spec/fixtures/template.html' }
  let(:uid)       { 666 }
  
  it 'should generate proper body' do
    stub_const("UploadProgress::PUBLIC_UPLOADS_PATH", '/uploads')
    set_data_expectations_and_mocks
    
    expected = "<html><span class='path'>/uploads/#{uid}/fixture.txt,description</span></html>\n"

    up = UploadProgress::TemplateRenderer.new(uid)
    
    up.render(body_path).should == expected
  end

  def set_data_expectations_and_mocks
    description_manager = double
    UploadProgress::DescriptionManager.should_receive(:new).with(uid) { description_manager }
    description_manager.should_receive(:get) { 'description' }
    
    uploaded_file_manager = double
    UploadProgress::UploadedFileManager.should_receive(:new).with(uid) { uploaded_file_manager }
    uploaded_file_manager.should_receive(:get) { 'fixture.txt' }
  end

end
