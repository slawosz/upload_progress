require 'redis'

module UploadProgress
  class ProgressDataManager

    def initialize(uid)
      @uid = uid
      p uid
      @redis = Redis.new
    end

    def save(value)
      @redis.set(@uid.to_s, value)
    end

    def get
      @redis.get(@uid.to_s)
    end
    
  end
end
