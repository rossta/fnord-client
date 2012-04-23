module Fnord
  class UDPConnection

    attr_accessor :socket

    def initialize(host, port = 1337, options = {})
      @host, @port, @options = host, port, options
    end

    def send_data(data)
      # Rails.logger.info "[FNORD] Sending data\n#{data}"
      socket.send(data, 0, @host, @port)
    end

    def socket
      @socket ||= UDPSocket.new
    end

  end

end