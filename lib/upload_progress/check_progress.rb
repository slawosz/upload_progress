module UploadProgress
  class CheckProgress

    def call(env)
      uid = UidParser.new(env['QUERY_STRING']).parse
      progress = ProgressDataManager.new(uid).get
      [200, {}, progress]
    end
      
  end
end
