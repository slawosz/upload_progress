map '/' do
  run lambda {|env| [200,{}, File.read(File.dirname(__FILE__) + '/index.html')]}
end

map '/upload' do
  run UploadProgress::Upload.new(File.dirname(__FILE__) + '/upload_result.html')
end

map '/progress' do
  run UploadProgress::CheckProgress.new
end
