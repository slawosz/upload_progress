module UploadProgress
  class UidGetter
    def initialize(app)
      @app = app
    end

    def call(env)
      uid = UidParser.new(env['QUERY_STRING']).parse
      status, env, body = @app.call(env)
      [status, env.merge('X-UploadId' => uid), body]
    end
    
  end
end
