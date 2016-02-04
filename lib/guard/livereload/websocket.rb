require 'eventmachine'
require 'em-websocket'
require 'http/parser'
require 'uri'

module Guard
  class LiveReload
    class WebSocket < EventMachine::WebSocket::Connection
      HTTP_DATA_FORBIDDEN = "HTTP/1.1 403 Forbidden\r\nContent-Type: text/plain\r\nContent-Length: 13\r\n\r\n403 Forbidden"
      HTTP_DATA_NOT_FOUND = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: 13\r\n\r\n404 Not Found"

      def initialize(options)
        @livereload_js_path = options[:livereload_js_path]
        super
      end

      def dispatch(data)
        parser = Http::Parser.new
        parser << data
        # prepend with '.' to make request url usable as a file path
        request_path = '.' + URI.parse(parser.request_url).path
        request_path += '/index.html' if File.directory? request_path
        if parser.http_method != 'GET' || parser.upgrade?
          super # pass the request to websocket
        else
          _serve(request_path)
        end
      end

      private

      def _serve_file(path)
        UI.debug "Serving file #{path}"

        data = [
          'HTTP/1.1 200 OK',
          'Content-Type: %s',
          'Content-Length: %s',
          '',
          '']
        data = format(data * "\r\n", _content_type(path), File.size(path))
        send_data(data)
        stream_file_data(path).callback { close_connection_after_writing }
      end

      def _content_type(path)
        case File.extname(path).downcase
        when '.html', '.htm' then 'text/html'
        when '.css' then 'text/css'
        when '.js' then 'application/ecmascript'
        when '.gif' then 'image/gif'
        when '.jpeg', '.jpg' then 'image/jpeg'
        when '.png' then 'image/png'
        else; 'text/plain'
        end
      end

      def _livereload_js_path
        @livereload_js_path
      end

      def _serve(path)
        return _serve_file(_livereload_js_path) if path == './livereload.js'
        data = _readable_file(path) ? HTTP_DATA_FORBIDDEN : HTTP_DATA_NOT_FOUND
        send_data(data)
        close_connection_after_writing
      end

      def _readable_file(path)
        File.readable?(path) && !File.directory?(path)
      end
    end
  end
end
