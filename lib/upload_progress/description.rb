module UploadProgress
  class Description
    include HasUid

    def call(env)
      uid = get_uid(env)
      renderer  = TemplateRenderer.new(uid)
      if ProgressDataManager.new(uid).get == '100'
        return [200, {}, renderer.render(DESCRIPTION_TEMPLATE)]
      else
        return [200, {}, renderer.render(DESCRIPTION_PENDING_TEMPLATE)]
      end
    end
  end
end
