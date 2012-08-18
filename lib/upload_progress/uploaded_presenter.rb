module UploadProgress
  class UploadedPresenter
    def initialize(path, description)
      @path, @description = path, description
    end

    def body
      _body = File.read(TEMPLATE)
      _body.gsub!('_FILE_PATH_', @path)
      _body.gsub!('_DESCRIPTION_', @description)
      _body
    end
    
  end
end
