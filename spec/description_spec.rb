require 'spec_helper'

describe UploadProgress::Description do

  subject { UploadProgress::Description.new }

  before do
    progress_manager = double
    UploadProgress::ProgressDataManager.stub(:new) { progress_manager }
    progress_manager.should_receive(:get) { progress }
    
    stub_const(template_const, fixture_path)
    
    description_manager = double
    UploadProgress::DescriptionManager.stub(:new).with('666') { description_manager }
    description_manager.should_receive(:save).with('foo bar')

    renderer = double
    UploadProgress::TemplateRenderer.should_receive(:new).with('666') { renderer }
    renderer.should_receive(:render).with(constantize(template_const)) { response }
  end

  context 'when upload finished' do
    let(:progress) { '100' }
    let(:template_const) { 'UploadProgress::DESCRIPTION_TEMPLATE' }
    let(:fixture_path)  { UploadProgress::ROOT_PATH + '/spec/fixtures/description' }
    let(:response) { 'body' }

    it 'should return proper body' do
      status, _env, body = subject.call(env)

      status.should == 200
      _env.should == {}
      body.should == 'body'
    end
  end

  context 'when upload not finished' do
    let(:progress) { '50' }
    let(:template_const) { 'UploadProgress::DESCRIPTION_PENDING_TEMPLATE' }
    let(:fixture_path)  { UploadProgress::ROOT_PATH + '/spec/fixtures/description_pending' }
    let(:response) { 'pending' }
    
    before do
      body_path = UploadProgress::ROOT_PATH + '/spec/fixtures/description_pending'
    end
    
    it 'should return proper body' do
      status, _env, body = subject.call(env)
      
      status.should == 200
      _env.should == {}
      body.should == 'pending'
    end
  end

  def env
    {
      'X-UploadId'   => '666',
     'CONTENT_TYPE' => 'multipart/form-data; boundary=---------------------------18082441091101135728769216843',
     'rack.input'   => StringIO.new(rack_input),
     'CONTENT_LENGTH' => 185
    }
  end

  def rack_input
    "-----------------------------18082441091101135728769216843\r\nContent-Disposition: form-data; name=\"description\"\r\n\r\nfoo bar\r\n-----------------------------18082441091101135728769216843--\r\n"
  end

end
