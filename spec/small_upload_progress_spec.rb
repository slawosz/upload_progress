require 'spec_helper'

describe UploadProgress::SmallUploadProgress do

  it 'should set progress when content is small' do
    progress_manager = double
    UploadProgress::ProgressDataManager.should_receive(:new).with('666') { progress_manager }
    progress_manager.should_receive(:save).with('100'
                                                )

    @io = StringIO.new

    response = UploadProgress::SmallUploadProgress.new(app).call(env)
    response.should == app.call(env)
  end

  it 'should not set progress when content is big' do
    UploadProgress::ProgressDataManager.should_not_receive(:new)

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
