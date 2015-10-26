require 'guard/compat/plugin'

module Guard
  class LiveReload < Plugin
    require 'guard/livereload/websocket'
    require 'guard/livereload/reactor'
    require 'guard/livereload/snippet'

    attr_accessor :reactor, :options

    def initialize(options = {})
      super

      js_path = File.expand_path('../../../js/livereload.js.erb', __FILE__)
      @options = {
        host:           '0.0.0.0',
        port:           '35729',
        apply_css_live: true,
        override_url:   false,
        grace_period:   0,
        js_template: js_path,
        js_options: {}
      }.merge(options)

      %i(js_apple_webkit_extra_wait_time js_default_extra_wait_time).each do |key|
        if options.keys.include?(key)
          Guard::Compat::UI.deprecation "#{key.inspect} is deprecated. Check out :js_options parameter instead."
          new_key = key.to_s.sub(/^js_/, '').to_sym
          @options[:js_options][new_key] ||= options[key]
          @options.delete(key)
        end
      end

      js_path = @options[:js_template]

      # NOTE: save snippet as instvar, so it's not GC'ed
      @snippet = Snippet.new(js_path, @options)
      @options[:livereload_js_path] = @snippet.path
    end

    def start
      @reactor = Reactor.new(options)
    end

    def stop
      reactor.stop
    end

    def run_on_modifications(paths)
      sleep options[:grace_period]
      reactor.reload_browser(paths)
    end
  end
end
