module UploadProgress
  class UploadedFileStore < Store
    def key
      'file_name'
    end
  end
end
