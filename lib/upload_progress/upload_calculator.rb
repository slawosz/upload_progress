module UploadProgress
  class UploadCalculator

    def initialize(uploaded, content_length)
      @uploaded = uploaded
      @content_length = content_length
    end

    def calculate
      return 0 if empty_content_length?
      result = @uploaded.to_f / @content_length.to_f
      result *= 100

      result > 100 ? 100 : result.to_i
    end

    private

    def empty_content_length?
      @content_length.nil? || @content_length == 0
    end
        
  end
end
