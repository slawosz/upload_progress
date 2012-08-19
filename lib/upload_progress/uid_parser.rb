module UploadProgress
  class UidParser

    def initialize(query_string)
      @query_string = query_string
    end

    def parse
      return nil if uid_cannot_be_obtained?
      @query_string.match(/uid=(\d+)/)[1]
    end

    private

    def uid_cannot_be_obtained?
      @query_string == nil || @query_string !~ /uid=\d+/
    end
    
  end
end
