require 'guard'
require 'guard/guard'

module Guard
  class LiveReload < Guard
    
    autoload :Reactor, 'guard/livereload/reactor'
    attr_accessor :reactor
    
    def start
      options[:api_version]    ||= '1.4'
      options[:host]           ||= '0.0.0.0'
      options[:port]           ||= '35729'
      options[:apply_js_live]  ||= true
      options[:apply_css_live] ||= true
      
      @reactor = Reactor.new(options)
    end
    
    def stop
      reactor.stop
    end
    
    def run_on_change(paths)
      reactor.reload_browser(paths)
    end
    
  end
end