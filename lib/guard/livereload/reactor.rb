require 'multi_json'

module Guard
  class LiveReload
    class Reactor
      attr_reader :web_sockets, :thread, :options

      def initialize(options)
        @web_sockets = []
        @options     = options
        @thread      = Thread.new { _start_reactor }
      end

      def stop
        thread.kill
      end

      def reload_browser(paths = [])
        UI.info "Reloading browser: #{paths.join(' ')}"
        paths.each do |path|
          data = _data(path)
          UI.debug(data)
          web_sockets.each { |ws| ws.send(MultiJson.encode(data)) }
        end
      end

    private

      def _data(path)
        data = {
          command: 'reload',
          path:    "#{Dir.pwd}/#{path}",
          liveCSS: options[:apply_css_live]
        }
        if options[:override_url] && File.exist?(path)
          data[:overrideURL] = '/' + path
        end
        data
      end

      def _start_reactor
        EventMachine.epoll
        EventMachine.run do
          UI.info "LiveReload is waiting for a browser to connect."
          EventMachine.start_server(options[:host], options[:port], WebSocket) do |ws|
            ws.onopen &_on_open
            ws.onmessage &_on_message
            ws.onmessage &_on_close
          end
        end
      end

      def _on_open
        UI.info "Browser connected."
        self.send MultiJson.encode(
          command:    'hello',
          protocols:  ['http://livereload.com/protocols/official-7'],
          serverName: 'guard-livereload'
        )
        @web_sockets << self
      rescue
        UI.errror $!
        UI.errror $!.backtrace
      end

      def _on_message(message)
        message = MultiJson.decode(message)
        UI.info"Browser URL: #{message['url']}" if message['command'] == 'url'
      end

      def _on_close
        UI.info "Browser disconnected."
        @web_sockets.delete(self)
      end

    end
  end
end
