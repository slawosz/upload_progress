module UploadProgress
  class Description
    include HasUid

    def call(env)
      @env = env
      @uid = get_uid(@env)

      save_description
      
      renderer  = TemplateRenderer.new(@uid)
      if ProgressDataStore.new(@uid).get == '100'
        return [200, {}, renderer.render(DESCRIPTION_TEMPLATE)]
      else
        return [200, {}, renderer.render(DESCRIPTION_PENDING_TEMPLATE)]
      end
    end

    private

    def save_description
      dm = DescriptionStore.new(@uid)
      dm.save(description)
    end

    def description
      Rack::Multipart.parse_multipart(@env)["description"]
    end
    
  end
end
