require_relative 'upload_progress/has_uid.rb'
require_relative 'upload_progress/upload_calculator.rb'
require_relative 'upload_progress/store.rb'
require_relative 'upload_progress/progress_data_store.rb'
require_relative 'upload_progress/description_store.rb'
require_relative 'upload_progress/uploaded_file_store.rb'
require_relative 'upload_progress/check_progress.rb'
require_relative 'upload_progress/uid_parser.rb'
require_relative 'upload_progress/upload.rb'
require_relative 'upload_progress/description.rb'
require_relative 'upload_progress/small_upload_progress.rb'
require_relative 'upload_progress/template_renderer.rb'
require_relative 'upload_progress/uid_getter.rb'
require_relative 'upload_progress/handlers/thin'

module UploadProgress
  ROOT_PATH = "#{File.dirname(__FILE__)}/.."
  UPLOADS_PATH = '/public/uploads'
  PUBLIC_UPLOADS_PATH = '/uploads'
  TEMPLATE = ROOT_PATH + '/lib/upload_progress/templates/upload_complete.html'
  DESCRIPTION_TEMPLATE = ROOT_PATH + '/lib/upload_progress/templates/description.js'
  DESCRIPTION_PENDING_TEMPLATE = ROOT_PATH + '/lib/upload_progress/templates/description_pending.js'
end
