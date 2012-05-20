require 'guard'
require 'guard/guard'

module Guard
  class LiveReload < Guard
    attr_accessor :reactor
    autoload :Reactor, 'guard/livereload/reactor'

    # =================
    # = Guard methods =
    # =================

    def initialize(watchers = [], options = {})
      super
      @options = {
        :api_version => '1.6',
        :host => '0.0.0.0',
        :port => '35729',
        :apply_js_live => true,
        :apply_css_live => true,
        :grace_period => 0
      }.update(options)
    end

    def start
      @reactor = Reactor.new(@options)
    end

    def stop
      reactor.stop
    end

    def run_on_changes(paths)
      sleep @options[:grace_period]
      reactor.reload_browser(paths)
    end

  end
end
