require 'guard'
require 'guard/guard'

module Guard
  class LiveReload < Guard
    
    autoload :Reactor, 'guard/livereload/reactor'
    
    attr_accessor :reactor
    
    # =================
    # = Guard methods =
    # =================
    
    def initialize(watchers = [], options = {})
      super
      @options[:api_version]    = options[:api_version] || '1.4'
      @options[:host]           = options[:host] || '0.0.0.0'
      @options[:port]           = options[:port] || '35729'
      @options[:apply_js_live]  = options[:apply_js_live].nil? ? true : options[:apply_js_live]
      @options[:apply_css_live] = options[:apply_css_live].nil? ? true : options[:apply_css_live]
    end
    
    def start
      @reactor = Reactor.new(@options)
    end
    
    def stop
      reactor.stop
    end
    
    def run_on_change(paths)
      reactor.reload_browser(paths)
    end
    
  end
end