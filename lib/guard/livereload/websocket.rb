require 'eventmachine'
require 'em-websocket'
require 'guard/livereload/websocket/dispatcher'

module Guard
  class LiveReload
    class WebSocket < EventMachine::WebSocket::Connection
      def initialize(options)
        @dispatcher = Dispatcher.new(options)
        super
      end

      def dispatch(data)
        responses = @dispatcher.dispatch(data)

        responses.each do |type, payload|
          case type
          when :default
            super
          when :data
            send_data(payload)
          when :close_write
            close_connection_after_writing
          when :file
            path = payload
            stream_file_data(path).callback { close_connection_after_writing }
          else
            fail "Unknown response type: #{type.inspect}"
          end
        end
      end
    end
  end
end
