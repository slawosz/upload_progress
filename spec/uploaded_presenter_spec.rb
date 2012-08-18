require 'spec_helper'

describe UploadProgress::UploadedPresenter do

  before do
    body_path = UploadProgress::ROOT_PATH + '/spec/fixtures/template.html'
    stub_const('UploadProgress::TEMPLATE', body_path)
  end
  
  it 'should generate proper body' do
    expected = "<html><span class='path'>path,description</span></html>\n"

    up = UploadProgress::UploadedPresenter.new('path', 'description')
    
    up.body.should == expected
  end

end
