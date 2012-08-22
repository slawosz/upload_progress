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
    description_store = double
    UploadProgress::DescriptionStore.should_receive(:new).with(uid) { description_store }
    description_store.should_receive(:get) { 'description' }
    
    uploaded_file_store = double
    UploadProgress::UploadedFileStore.should_receive(:new).with(uid) { uploaded_file_store }
    uploaded_file_store.should_receive(:get) { 'fixture.txt' }
  end

end
