module UploadProgress
  module HasUid
    def get_uid(env)
      env['X-UploadId'] rescue nil
    end
  end
end
