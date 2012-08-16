module UploadProgress
  class Upload

    def initialize(body_path)
      @body_path = body_path
    end

    def call(env)
      @env = env
      [200, {}, prepare_body]
    end

    private
    
    def prepare_body
      body = File.read(@body_path)
      file_path = FileManager.new(@env).create_file
      body.gsub(/_FILE_PATH_/, file_path)
    end

    class FileManager

      def initialize(env)
        @uploaded = Rack::Multipart.parse_multipart(env)
      end

      def create_file
        file = @uploaded['files']
        dir_name = UPLOADS_PATH + '/' + next_folder_num + '/'
        file_path = dir_name + file[:filename]
        
        FileUtils.mkdir(ROOT_PATH + dir_name)
        FileUtils.cp(file[:tempfile].path, ROOT_PATH + file_path)
        file_path
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
