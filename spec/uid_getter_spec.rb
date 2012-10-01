require 'spec_helper'

describe UploadProgress::UidGetter do
  
  it 'should pass uid to headers' do
    u = UploadProgress::UidGetter.new(app)
    expect { u.call(env) }.to_not raise_error(RuntimeError)
    expect { u.call(env) }.to_not raise_error(ArgumentError)
  end

  def app
    lambda do |env|
      raise unless env['X-UploadId']
      [200, env, 'body']
    end
  end

  def env
    {'QUERY_STRING' => 'uid=666'}
  end
  
end
