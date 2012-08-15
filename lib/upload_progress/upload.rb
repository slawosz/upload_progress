module UploadProgress
  class Upload

    def initialize(body_path)
      @body_path = body_path
    end

    def call(env)
      @file_path = FileManager.new(env).create_file
      [200, {}, prepare_body]
    end

    private
    
    def prepare_body
      body = File.read(@body_path)
      body.gsub(/_FILE_PATH_/, @file_path)
    end

    class FileManager

      def initialize(env)
        @uploaded = Rack::Multipart.parse_multipart(env)
      end

      def create_file
        file = @uploaded['files']
        dir_name = FILES_PATH + '/' + next_folder_num + '/'
        file_path = dir_name + file[:filename]
        
        FileUtils.mkdir(dir_name)
        FileUtils.cp(file[:tempfile].path, file_path)
        file_path
      end

      private

      def next_folder_num
        num  = (`ls #{FILES_PATH}`.split("\n").map(&:to_i).sort.last || 0) + 1
        num.to_s
      end
      
    end
    
  end
end
