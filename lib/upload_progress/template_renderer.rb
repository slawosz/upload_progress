module UploadProgress
  class TemplateRenderer
    
    def initialize(uid)
      @uid = uid
    end

    def render(template_path)
      body = File.read(template_path)
      body.gsub!('_FILE_PATH_', path)
      body.gsub!('_DESCRIPTION_', description)
      body
    end

    def path
      PUBLIC_UPLOADS_PATH + '/' + @uid.to_s + '/' + UploadedFileManager.new(@uid).get
    end

    def description
      DescriptionManager.new(@uid).get
    end
    
  end
end
