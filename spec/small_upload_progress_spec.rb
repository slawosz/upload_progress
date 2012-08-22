require 'spec_helper'

describe UploadProgress::SmallUploadProgress do

  it 'should set progress when content is small' do
    progress_store = double
    UploadProgress::ProgressDataStore.should_receive(:new).with('666') { progress_store }
    progress_store.should_receive(:save).with('100'
                                                )

    @io = StringIO.new

    response = UploadProgress::SmallUploadProgress.new(app).call(env)
    response.should == app.call(env)
  end

  it 'should not set progress when content is big' do
    UploadProgress::ProgressDataStore.should_not_receive(:new)

    @io = Tempfile.new('/tmp/foo')

    response = UploadProgress::SmallUploadProgress.new(app).call(env)
    response.should == app.call(env)
  end

  def app
    lambda {|env| [200, {'foo' => 'bar'}, 'body']}
  end
  
  def env
    {
      'X-UploadId'   => '666',
      'rack.input'   => @io
    }
  end
  
end
