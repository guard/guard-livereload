require 'erb'
require 'tempfile'

require 'guard/compat/plugin'

module Guard
  class LiveReload < Plugin
    class Snippet
      attr_reader :path
      attr_reader :options

      def initialize(template, options)
        @options = options # for ERB context

        # NOTE: use instance variable for Tempfile, so it's not GC'ed before sending
        @tmpfile = Tempfile.new('livereload.js')
        source = IO.read(template)
        data = ERB.new(source).result(binding)
        @tmpfile.write(data)
        @tmpfile.close
        @path = @tmpfile.path
      end
    end
  end
end
