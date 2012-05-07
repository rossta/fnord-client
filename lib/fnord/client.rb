require 'yajl'
require 'socket'

module Fnord
  class Client
    attr_reader :host, :port, :options

    class << self
      # Set to any standard logger instance (including stdlib's Logger) to enable
      attr_accessor :logger, :namespace
    end

    attr_accessor :connection

    def initialize(host, port = 1337, options = {})
      @host, @port, @options = host, port, options
    end

    # Public: Send event to FnordMetric server as json
    #
    # text    - event name
    # options - additional data for payload
    #
    # Examples
    #
    #   event('page_view')
    #   # => emits "{\"_type\":\"page_view\",\"_namespace\":\"staging\"}"
    #
    #   event('page_view', :user_id => 1)
    #   # => emits "{\"_type\":\"page_view\",\"user_id\":\"1\"}"
    #
    #   event(:_type => 'page_view', :user_id => 1)
    #   # => emits "{\"_type\":\"page_view\",\"user_id\":\"1\"}"
    #
    # Emits given event name and options as json.
    def event(*args)
      message = extract_options!(args)
      event_name = args.shift
      message[:_type] = event_name if event_name
      message[:_namespace] = self.class.namespace unless message[:_namespace]
      send_to_connection(to_json(stringify_values(message)))
    end

    def connection
      @connection ||= connection_class.new(@host, @port, @options)
    end

    private

    def protocol
      @protocol ||= @options.delete(:protocol) || :udp
    end

    def connection_class
      case protocol
      when :tcp
        TCPConnection
      else
        UDPConnection
      end
    end

    def send_to_connection(message)
      self.class.logger.debug {"Fnord: #{message}"} if self.class.logger
      connection.send_data(message)
    rescue => boom
      self.class.logger.error {"Fnord: #{boom.class} #{boom}"} if self.class.logger
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