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
        handle_upload_progress
        save_progress
        super(data)
      end

      private
      
      def handle_upload_progress
        return unless uid
        @progress = UploadCalculator.new(@uploaded, @request.content_length).calculate
      end

      def uid
        @uid ||= begin
                   if _uid = @request.env['X-UploadId']
                     @uid = _uid
                   end
                 end
      end

      def save_progress
        @progress_data_manager ||= begin
                                     ProgressDataManager.new(@uid)
                                   end
        @progress_data_manager.save(@progress)        
      end

    end
  end
end

module Thin
  class UploadProgressConnection < Connection
    include UploadProgress::Handler::Thin
  end
end

module Thin
  module Backends
    module UploadProgressBackend
      @signature = EventMachine.start_server(@host, @port, Thin::UploadProgressConnection, &method(:initialize_connection))
    end
  end
end
