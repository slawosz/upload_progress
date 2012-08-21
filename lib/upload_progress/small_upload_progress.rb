require 'tempfile'

module UploadProgress
  class SmallUploadProgress
    include HasUid
    
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env
      if small_upload_body?
        ProgressDataManager.new(get_uid(env)).save('100')
      end
      @app.call(env)
    end

    private

    def small_upload_body?
      @env['rack.input'].class == StringIO
    end
    
  end
end
