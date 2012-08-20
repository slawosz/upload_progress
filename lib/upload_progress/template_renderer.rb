module UploadProgress
  class TemplateRenderer
    
    def initialize(template_path, path, description)
      @template_path = template_path
      @path = path
      @description = description
    end

    def render
      body = File.read(@template_path)
      body.gsub!('_FILE_PATH_', @path)
      body.gsub!('_DESCRIPTION_', @description)
      body
    end
    
  end
end
