module UploadProgress
  class UidGetter
    def initialize(app)
      @app = app
    end

    def call(env)
      uid = UidParser.new(env['QUERY_STRING']).parse
      @app.call(env.merge('X-UploadId' => uid))
    end
    
  end
end
