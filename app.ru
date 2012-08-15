map '/' do
  run lambda {|env| [200,{}, File.read('/home/slawosz/sc-research/upload_progress/index.html')]}
end

map '/upload' do
  run UploadProgress::Upload.new('/home/slawosz/sc-research/upload_progress/upload_result.html')
end

map '/progress' do
  run UploadProgress::CheckProgress.new
end
