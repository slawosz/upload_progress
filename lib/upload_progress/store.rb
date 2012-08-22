require 'redis'

module UploadProgress
  class Store

    def initialize(uid)
      @uid = uid
      @redis = Redis.new
    end

    def save(value)
      @redis.hset(@uid.to_s, key, value)
    end

    def get
      @redis.hget(@uid.to_s, key).to_s
    end

  end
end
