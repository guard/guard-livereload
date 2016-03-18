require 'guard/compat/plugin'

module Guard
  class LiveReload < Plugin
    class GuaranteedSleep
      def sleep(seconds)
        deadline = Time.now + seconds
        while (remaining = deadline - Time.now) > 0
          Kernel.sleep(remaining)
        end
      end
    end
  end
end
