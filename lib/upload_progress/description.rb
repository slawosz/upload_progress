module UploadProgress
  class Description
    include HasUid

    def call(env)
      @env = env
      @uid = get_uid(@env)

      save_description
      
      renderer = TemplateRenderer.new(@uid)
      if ProgressDataStore.new(@uid).get == '100'
        return [200, {'Content-Type' => 'application/javascript; charset=utf-8'}, renderer.render(DESCRIPTION_TEMPLATE)]
      else
        return [200, {'Content-Type' => 'application/javascript; charset=utf-8'}, renderer.render(DESCRIPTION_PENDING_TEMPLATE)]
      end
    end

    private

    def save_description
      dm = DescriptionStore.new(@uid)
      dm.save(description)
    end

    def description
      @env['rack.input'].read.match(/description=(.*)/)[1]
    rescue
      nil
    end
    
  end
end
