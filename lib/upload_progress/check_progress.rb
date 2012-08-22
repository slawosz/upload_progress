module UploadProgress
  class CheckProgress
    include HasUid

    def call(env)
      uid = get_uid(env)
      progress = ProgressDataStore.new(uid).get.to_s
      [200, {'Date' => Time.now.to_s, 'Content-Length' => progress.length.to_s, 'Content-Type' => 'text/html'}, progress]
    end
      
  end
end
