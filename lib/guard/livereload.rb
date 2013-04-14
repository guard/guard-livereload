require 'guard'
require 'guard/guard'

module Guard
  class LiveReload < Guard
    require 'guard/livereload/websocket'
    require 'guard/livereload/reactor'

    attr_accessor :reactor, :options

    # =================
    # = Guard methods =
    # =================

    def initialize(watchers = [], options = {})
      super
      @options = {
        :host => '0.0.0.0',
        :apply_css_live => true,
        :override_url => false,
        :grace_period => 0
      }.update(options)
    end

    def start
      @reactor = Reactor.new(options)
    end

    def stop
      reactor.stop
    end

    def run_on_changes(paths)
      sleep options[:grace_period]
      reactor.reload_browser(paths)
    end

  end
end
