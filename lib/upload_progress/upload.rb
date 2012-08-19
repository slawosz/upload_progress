require 'rack/multipart'

module UploadProgress
  class Upload
    include HasUid

    def call(env)
      @env = env
      @uid = get_uid(@env)
      process_upload
      [200, {}, prepare_body]
    end

    private

    def process_upload
      @file_manager = FileManager.new(@env)
      @file_manager.create_file
    end
    
    def prepare_body
      description = DescriptionManager.new(@uid).get
      UploadedPresenter.new(@file_manager.public_path, description).body
    end

    class FileManager
      include HasUid

      attr_reader :public_path
      
      def initialize(env)
        @env = env
        @uploaded = Rack::Multipart.parse_multipart(env)
      end

      def create_file
        file = @uploaded['files']
        new_dir = '/' + get_uid(@env) + '/'
        new_location = new_dir + file[:filename]
        FileUtils.mkdir(ROOT_PATH + UPLOADS_PATH + new_dir)
        
        move_to = UPLOADS_PATH + new_location
        FileUtils.cp(file[:tempfile].path, ROOT_PATH + move_to)
        @public_path = PUBLIC_UPLOADS_PATH + new_location
      end

      private

      def uploads_path
        ROOT_PATH + UPLOADS_PATH
      end
      
    end
    
  end
end
