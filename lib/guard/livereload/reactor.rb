require 'multi_json'
require 'guard/livereload/http-ws'

module Guard
  class LiveReload
    class Reactor

      attr_reader :thread, :web_sockets

      def initialize(options)
        @web_sockets = []
        @options     = options
        @thread      = start_threaded_reactor(options)
      end

      def stop
        thread.kill
      end

      def reload_browser(paths = [])
        UI.info "Reloading browser: #{paths.join(' ')}"
        paths.each do |path|
          data = {
            :command        => 'reload',
            :path           => "#{Dir.pwd}/#{path}",
            :liveCSS => @options[:apply_css_live]
          }
          if @options[:overrideURL] && File.exist?(path)
            data[:overrideURL] = '/' + path
          end
          UI.debug data
          @web_sockets.each { |ws| ws.send(MultiJson.encode(data)) }
        end
      end

    private

      def start_threaded_reactor(options)
        Thread.new do
          EventMachine.run do
            UI.info "LiveReload is waiting for a browser to connect."
            EventMachine.start_server(options[:host], options[:port], HTTP_Websocket, {}) do |ws|
              ws.onopen do
                begin
                  UI.info "Browser connected."
                  ws.send MultiJson.encode({
                    :command => 'hello',
                    :protocols =>
                      [
                        'http://livereload.com/protocols/official-7',
                      ],
                    :serverName => 'guard-livereload'
                  })
                  @web_sockets << ws
                rescue
                  UI.errror $!
                  UI.errror $!.backtrace
                end
              end

              ws.onmessage do |msg|
                msg = MultiJson.decode(msg)
                if msg['command'] == 'url'
                  UI.info "Browser URL: #{msg['url']}"
                end
              end

              ws.onclose do
                @web_sockets.delete ws
                UI.info "Browser disconnected."
              end
            end
          end
        end
      end

    end
  end
end
