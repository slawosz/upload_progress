require_relative 'upload_progress/upload_calculator.rb'
require_relative 'upload_progress/progress_data_manager.rb'
require_relative 'upload_progress/check_progress.rb'
require_relative 'upload_progress/uid_parser.rb'
require_relative 'upload_progress/upload.rb'
require_relative 'upload_progress/handlers/thin'
require 'fileutils'
require 'stringio'
require 'rack'

module UploadProgress
  ROOT_PATH = FileUtils.pwd
  FILES_PATH = ROOT_PATH + '/public/files'
end
