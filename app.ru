use Rack::Static, root: 'public', index: 'index.html'#, urls: { "/" => 'index.html' }
run Rack::File.new(UploadProgress::ROOT_PATH + '/public')

map '/upload' do
  run UploadProgress::Upload.new(File.dirname(__FILE__) + '/upload_result.html')
end

map '/progress' do
  run UploadProgress::CheckProgress.new
end


