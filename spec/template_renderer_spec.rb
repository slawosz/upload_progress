require 'spec_helper'

describe UploadProgress::TemplateRenderer do

  let(:body_path) { UploadProgress::ROOT_PATH + '/spec/fixtures/template.html' }
  
  it 'should generate proper body' do
    expected = "<html><span class='path'>path,description</span></html>\n"

    up = UploadProgress::TemplateRenderer.new(body_path, 'path', 'description')
    
    up.render.should == expected
  end

end
