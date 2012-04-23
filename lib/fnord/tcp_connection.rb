module Fnord
  class TCPConnection

    attr_accessor :socket

    def initialize(host, port = 1337, options = {})
      @host, @port, @options = host, port, options
    end

    def send_data(data)
      ensure_connected(:retry => true) do
        # Rails.logger.info "[FNORD] Sending data\n#{data}"
        @socket.puts(data)
        @socket.flush
      end
    end

    def connect
      @socket = TCPSocket.new(@host, @port)
    end

    def reconnect
      # untested
      disconnect
      connect
    end

    def disconnect
      # untested
      return unless connected?

      begin
        @socket.close
      rescue
      ensure
        @socket = nil
      end
    end

    def connected?
      !!@socket
    end

    private

    def ensure_connected(opts = {}, &block)
      begin
        connect unless connected?
        yield
      rescue Errno::ECONNRESET, Errno::EPIPE, Errno::ECONNABORTED, Errno::ECONNREFUSED => e
        if opts[:retry]
          ensure_connected(:retry => false, &block)
        else
          if @options[:raise_errors]
            raise e
          else
            # Rails.logger.warn "[FNORD] Could not connect to fnord at #{@host}:#{@port}"
          end
        end
      end
    end
  end
end