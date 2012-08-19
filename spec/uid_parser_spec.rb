require 'spec_helper'

describe UploadProgress::UidParser do
  it 'should get uid' do
    up = UploadProgress::UidParser.new('?uid=666')
    up.parse.should == '666'
  end

  it 'shoud return nil when @uid is nil' do
    up = UploadProgress::UidParser.new(nil)
    up.parse.should == nil
  end
end
