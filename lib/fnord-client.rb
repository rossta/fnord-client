require "fnord/version"

module Fnord
  autoload :Client, 'fnord/client'
  autoload :UDPConnection, 'fnord/udp_connection'
  autoload :TCPConnection, 'fnord/tcp_connection'
end