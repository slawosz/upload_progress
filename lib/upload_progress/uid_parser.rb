module UploadProgress
  class UidParser

    def initialize(uid)
      @uid = uid
    end

    def parse
      return nil unless @uid
      @uid.match(/uid=(\d+)/)[1]
    end
  end
end
