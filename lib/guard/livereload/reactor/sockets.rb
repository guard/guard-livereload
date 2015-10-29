require 'thread'

module Guard
  class LiveReload < Plugin
    class Reactor
      class Sockets
        def initialize
          @sockets = []
          @mutex = Mutex.new
        end

        def internal_list
          @mutex.synchronize { @sockets }
        end

        def size
          @mutex.synchronize { @sockets.size }
        end

        def broadcast(json)
          @mutex.synchronize do
            @sockets.each { |ws| ws.send(json) }
          end
        end

        def add(socket)
          @mutex.synchronize do
            yield socket if block_given? # within mutex, so 'hello' has a chance to be sent
            @sockets << socket
          end
        end

        def delete(socket)
          @mutex.synchronize { @sockets.delete(socket) }
        end

        def empty?
          @mutex.synchronize { @sockets.empty? }
        end
      end
    end
  end
end
