require_relative 'upload_progress/has_uid.rb'
require_relative 'upload_progress/upload_calculator.rb'
require_relative 'upload_progress/manager.rb'
require_relative 'upload_progress/progress_data_manager.rb'
require_relative 'upload_progress/description_manager.rb'
require_relative 'upload_progress/uploaded_file_manager.rb'
require_relative 'upload_progress/check_progress.rb'
require_relative 'upload_progress/uid_parser.rb'
require_relative 'upload_progress/upload.rb'
require_relative 'upload_progress/description.rb'
require_relative 'upload_progress/template_renderer.rb'
require_relative 'upload_progress/uid_getter.rb'
require_relative 'upload_progress/handlers/thin'

module UploadProgress
  ROOT_PATH = "#{File.dirname(__FILE__)}/.."
  UPLOADS_PATH = '/public/uploads'
  PUBLIC_UPLOADS_PATH = '/uploads'
  TEMPLATE = ROOT_PATH + '/lib/upload_progress/template.html'
  DESCRIPTION_TEMPLATE = ROOT_PATH + '/lib/upload_progress/description.js'
  DESCRIPTION_PENDING_TEMPLATE = ROOT_PATH + '/lib/upload_progress/description_pending.js'
end
