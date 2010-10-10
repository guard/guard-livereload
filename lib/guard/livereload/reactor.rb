require 'em-websocket'
require 'json'

module Guard
  class LiveReload
    class Reactor
      
      attr_reader :thread, :web_sockets
      
      def initialize(options)
        @web_sockets = []
        @thread = start_threaded_reactor(options)
      end
      
      def stop
        thread.kill
      end
      
      def reload_browser(paths = [])
        UI.info "Reloading browser: #{paths.join(' ')}"
        paths.each do |path|
          data = ['refresh', { :path => path, :apply_js_live => false, :apply_css_live => true }].to_json
          UI.debug data
          @web_sockets.each { |ws| ws.send(data) }
        end
      end
      
    private
      
      def start_threaded_reactor(options)
        Thread.new do
          EventMachine.run do
            UI.info "LiveReload #{options[:api_version]} is waiting for a browser to connect."
            EventMachine::WebSocket.start(:host => options[:host], :port => options[:port]) do |ws|
              ws.onopen do
                begin
                  UI.info "Browser connected."
                  ws.send "!!ver:#{options[:api_version]}"
                  @web_sockets << ws
                rescue
                  UI.errror $!
                  UI.errror $!.backtrace
                end
              end
              
              ws.onmessage do |msg|
                UI.info "Browser URL: #{msg}"
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