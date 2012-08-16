module UploadProgress
  class CheckProgress

    def call(env)
      uid = UidParser.new(env['QUERY_STRING']).parse
      progress = ProgressDataManager.new(uid).get.to_s
      [200, {'Date' => Time.now.to_s, 'Content-Length' => progress.length.to_s, 'Content-Type' => 'text/html'}, progress]
    end
      
  end
end
