require 'yajl'

module Fnord
  class Client
    attr_reader :host, :port, :options

    class << self
      # Set to any standard logger instance (including stdlib's Logger) to enable
      # stat logging using logger.debug
      attr_accessor :logger, :namespace
    end

    attr_accessor :connection

    def initialize(host, port = 1337, options = {})
      @host, @port, @options = host, port, options
    end

    def event(*args)
      message = extract_options!(args)
      event_name = args.shift
      message[:_type] = event_name if event_name
      message[:_namespace] = self.class.namespace unless message[:_namespace]
      message = stringify_values(message)
      send_to_connection(to_json(message))
    end

    private

    def send_to_connection(message)
      self.class.logger.debug {"Fnord: #{message}"} if self.class.logger
      connection.send_data(message)
    rescue => boom
      self.class.logger.error {"Fnord: #{boom.class} #{boom}"} if self.class.logger
    end

    def connection
      @connection ||= UDPConnection.new(@host, @port, @options)
    end

    def stringify_values(message)
      {}.tap { |hash| message.each { |k, v| hash[k] = v.to_s } }
    end

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

    def to_json(hash)
      Yajl::Encoder.encode(hash)
    end

  end
end