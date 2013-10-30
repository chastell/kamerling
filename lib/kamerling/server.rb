require 'gserver'
require 'logger'

module Kamerling class Server
  def initialize(handler: Handler.new, host: '127.0.0.1',
                 logger: Logger.new('/dev/null'), tcp_port: 0, udp_port: 0)
    @tcp_server = TCP.new handler: handler, host: host, logger: logger,
      port: tcp_port
    @udp_server = UDP.new handler: handler, host: host, logger: logger,
      port: udp_port
  end

  def join
    tcp_server.join
  end

  def start
    udp_server.start
    tcp_server.start
    self
  end

  def tcp_addr
    tcp_server.addr
  end

  def udp_addr
    udp_server.addr
  end

  attr_reader :udp_server, :tcp_server
  private     :udp_server, :tcp_server
end end
