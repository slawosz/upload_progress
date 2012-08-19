module UploadProgress
  class UidParser

    def initialize(uid)
      @uid = uid
    end

    def parse
      @uid.match(/uid=(\d+)/)[1]
    end
  end
end
