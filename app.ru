use Rack::Static, root: 'public', index: 'index.html'
use UploadProgress::UidGetter
run Rack::File.new(UploadProgress::ROOT_PATH + '/public')

map '/upload' do
  use UploadProgress::SmallUploadProgress
  run UploadProgress::Upload.new
end

map '/progress' do
  run UploadProgress::CheckProgress.new
end

map '/description' do
  run UploadProgress::Description.new
end
