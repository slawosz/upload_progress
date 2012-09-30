require 'spec_helper'

describe UploadProgress::UploadCalculator do

  subject { UploadProgress::UploadCalculator.calculate(@uploaded, @content_length) }

  
  it 'should calculate procent' do
    @uploaded = 25
    @content_length = 100

    subject.should == 25
  end

  it 'should never return bigger value than 100' do
    @uploaded = 105
    @content_length = 100

    subject.should == 100
  end

  it 'should return 0 if content length is 0' do
    @uploaded = 10
    @content_length = 0

    subject.should == 0
  end
  
  it 'should return 0 if content length is nil' do
    @uploaded = 10
    @content_length = nil

    subject.should == 0
  end
      
end
