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
        @progress = UploadCalculator.calculate(@uploaded, @request.content_length)
      end

      def save_progress
        return unless uid
        @progress_data_store ||= begin
                                     ProgressDataStore.new(@uid)
                                   end
        @progress_data_store.save(@progress)        
      end
      
      def uid
        @uid ||= begin
                   q = @request.env['QUERY_STRING']
                   if q && q.length > 0
                     UidParser.new(@request.env['QUERY_STRING']).parse
                   end
                 end
      end

    end
  end
end

module Thin
  class UploadProgressConnection < Connection
    include UploadProgress::Handlers::Thin
  end
end

module Thin
  module Backends
    class UploadProgressBackend < TcpServer

      def initialize(host, port, options)
        super(host, port)
      end
      
      def connect
        @signature = EventMachine.start_server(@host, @port, Thin::UploadProgressConnection, &method(:initialize_connection))
      end
    end
  end
end
