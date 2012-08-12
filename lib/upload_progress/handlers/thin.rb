module UploadProgress
  module Handlers
    module Thin

      def initialize(*args)
        @uploaded = 0
        @uid = nil
        super(*args)
      end

      def receive_data(data)
        @uploaded += data.length
        super(data)
      end
      
    end
  end
end
