require 'spec_helper'

describe UploadProgress::UidGetter do
  
  it 'should pass uid to headers' do
    u = UploadProgress::UidGetter.new(app)
    u.call(env).should == [200, {'QUERY_STRING' => 'uid=666', 'X-UploadId' => '666'}, 'body']
  end

  def app
    lambda {|env| [200, {'QUERY_STRING' => 'uid=666'}, 'body'] }
  end

  def env
    {'QUERY_STRING' => 'uid=666'}
  end
  
end
