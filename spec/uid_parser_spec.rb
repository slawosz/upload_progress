require 'spec_helper'

describe UploadProgress::UidParser do
  it 'should get uid' do
    up = UploadProgress::UidParser.parse('?uid=666')
    up.should == '666'
  end

  it 'shoud return nil when query string is nil' do
    up = UploadProgress::UidParser.parse(nil)
    up.should == nil
  end

  it 'should return nil when query string does not contain uid' do
    up = UploadProgress::UidParser.parse('foo=bar')
    up.should == nil
  end
  
end
