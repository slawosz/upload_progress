module UploadProgress
  class UidGetter
    def initialize(app)
      @app = app
    end

    def call(env)
      uid = UidParser.parse(env['QUERY_STRING'])
      @app.call(env.merge('X-UploadId' => uid))
    end
    
  end
end
