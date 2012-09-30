module UploadProgress
  class UidParser

    def self.parse(query_string)
      @query_string = query_string
      return nil if uid_cannot_be_obtained?
      @query_string.match(/uid=(\d+)/)[1]
    end

    private

    def self.uid_cannot_be_obtained?
      @query_string == nil || @query_string !~ /uid=\d+/
    end
    
  end
end
