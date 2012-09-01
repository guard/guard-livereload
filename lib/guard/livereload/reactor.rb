require 'em-websocket'
require 'multi_json'

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
        UI.info "Reloading browser: #{paths.join(' ')}", :reset => true
        paths.each do |path|
          data = MultiJson.encode(['refresh', {
            :path           => "#{Dir.pwd}/#{path}",
            :apply_js_live  => @options[:apply_js_live],
            :apply_css_live => @options[:apply_css_live]
          }])
          UI.debug data, :reset => true
          @web_sockets.each { |ws| ws.send(data) }
        end
      end

    private

      def start_threaded_reactor(options)
        Thread.new do
          EventMachine.run do
            UI.info "LiveReload #{options[:api_version]} is waiting for a browser to connect.", :reset => true
            EventMachine.start_server(options[:host], options[:port], EventMachine::WebSocket::Connection, {}) do |ws|
              ws.onopen do
                begin
                  UI.info "Browser connected.", :reset => true
                  ws.send "!!ver:#{options[:api_version]}"
                  @web_sockets << ws
                rescue
                  UI.errror $!, :reset => true
                  UI.errror $!.backtrace, :reset => true
                end
              end

              ws.onmessage do |msg|
                UI.info "Browser URL: #{msg}", :reset => true
              end

              ws.onclose do
                @web_sockets.delete ws
                UI.info "Browser disconnected.", :reset => true
              end
            end
          end
        end
      end

    end
  end
end
