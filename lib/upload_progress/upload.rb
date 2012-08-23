require 'rack/multipart'

module UploadProgress
  class Upload
    include HasUid

    def call(env)
      @env = env
      @uid = get_uid(@env)
      process_upload
      [200, {'Content-Type' => 'text/html; charset=utf-8'}, prepare_body]
    end

    private

    def process_upload
      @attachment_manager = AttachmentManager.new(@env)
      @attachment_manager.create_file
    end
    
    def prepare_body
      description = DescriptionStore.new(@uid).get
      TemplateRenderer.new(@uid).render(TEMPLATE)
    end

    class AttachmentManager
      include HasUid

      def initialize(env)
        @env = env
        @uploaded = Rack::Multipart.parse_multipart(env)
      end

      def create_file
        file = @uploaded['files']
        save_file_name
        new_dir = '/' + get_uid(@env) + '/'
        new_location = new_dir + file[:filename]
        FileUtils.mkdir(ROOT_PATH + UPLOADS_PATH + new_dir)
        
        move_to = UPLOADS_PATH + new_location
        FileUtils.cp(file[:tempfile].path, ROOT_PATH + move_to)
      end

      private

      def save_file_name
        UploadedFileStore.new(get_uid(@env)).save(@uploaded['files'][:filename])
      end
      
    end
    
  end
end
