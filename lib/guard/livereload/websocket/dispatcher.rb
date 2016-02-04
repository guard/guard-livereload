require 'guard/ui'
require 'eventmachine'
require 'em-websocket'
require 'http/parser'
require 'uri'

module Guard
  class LiveReload
    class WebSocket < EventMachine::WebSocket::Connection
      class Dispatcher
        class Http
          def self.build(header, message)
            [
              header,
              'Content-Type: text/plain',
              "Content-Length: #{message.size}",
              '',
              message
            ].join("\r\n").freeze
          end

          FORBIDDEN = build('HTTP/1.1 403 Forbidden', '403 Forbidden')
          NOT_FOUND = build('HTTP/1.1 404 Not Found', '404 Not Found')
        end

        def initialize(options)
          @livereload_js_path = options[:livereload_js_path]
        end

        def dispatch(data)
          parser = ::Http::Parser.new
          parser << data
          # prepend with '.' to make request url usable as a file path
          request_path = '.' + URI.parse(parser.request_url).path
          request_path += '/index.html' if File.directory? request_path
          if parser.http_method != 'GET' || parser.upgrade?
            [[:default, nil]]
          else
            _serve(request_path)
          end
        end

        private

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
          if path == './livereload.js'
            content_type = _content_type(path)
            real_path = _livereload_js_path
            data = _file_data_header(real_path, content_type)
            return [[:data, data], [:file, real_path]]
          end

          data = _readable_file(path) ? Http::FORBIDDEN : Http::NOT_FOUND
          [[:data, data], [:close_write, nil]]
        end

        def _readable_file(path)
          File.readable?(path) && !File.directory?(path)
        end

        def _file_data_header(path, content_type)
          UI.debug "Serving file #{path}"
          data = ['HTTP/1.1 200 OK', 'Content-Type: %s', 'Content-Length: %s', '', '']
          format(data * "\r\n", content_type, File.size(path))
        end
      end
    end
  end
end
