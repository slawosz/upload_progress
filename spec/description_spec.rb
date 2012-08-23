require 'spec_helper'

describe UploadProgress::Description do

  subject { UploadProgress::Description.new }

  before do
    progress_store = double
    UploadProgress::ProgressDataStore.stub(:new) { progress_store }
    progress_store.should_receive(:get) { progress }
    
    stub_const(template_const, fixture_path)
    
    description_store = double
    UploadProgress::DescriptionStore.stub(:new).with('666') { description_store }
    description_store.should_receive(:save).with('foo bar')

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
      _env.should == {'Content-Type' => 'application/javascript; charset=utf-8'}
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
      _env.should == {'Content-Type' => 'application/javascript; charset=utf-8'}
      body.should == 'pending'
    end
  end

  def env
    {
      'X-UploadId'   => '666',
     'rack.input'   => StringIO.new('description=foo bar'),
    }
  end

end
