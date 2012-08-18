require 'rack/multipart'

module UploadProgress
  class Upload

    def call(env)
      @env = env
      @uid = UidParser.new(env['QUERY_STRING']).parse
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

      attr_reader :public_path
      
      def initialize(env)
        @uploaded = Rack::Multipart.parse_multipart(env)
      end

      def create_file
        file = @uploaded['files']
        new_dir = '/' + next_folder_num + '/'
        new_location = new_dir + file[:filename]
        FileUtils.mkdir(ROOT_PATH + UPLOADS_PATH + new_dir)
        
        move_to = UPLOADS_PATH + new_location
        FileUtils.cp(file[:tempfile].path, ROOT_PATH + move_to)
        @public_path = PUBLIC_UPLOADS_PATH + new_location
      end

      private

      def next_folder_num
        num  = (`ls #{uploads_path}`.split("\n").map(&:to_i).sort.last || 0) + 1
        num.to_s
      end

      def uploads_path
        ROOT_PATH + UPLOADS_PATH
      end
      
    end
    
  end
end
