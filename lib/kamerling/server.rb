require 'gserver'
require 'logger'

module Kamerling class Server
  def initialize(handler: Handler.new, logger: Logger.new('/dev/null'),
                 host: '127.0.0.1', tcp_port: 0, udp_port: 0,
                 tcp: TCP.new(handler: handler, host: host, logger: logger,
                              port: tcp_port),
                 udp: UDP.new(handler: handler, host: host, logger: logger,
                              port: udp_port))
    @tcp, @udp = tcp, udp
  end

  def join
    tcp.join
  end

  def start
    tcp.start
    udp.start
    self
  end

  def tcp_addr
    tcp.addr
  end

  def udp_addr
    udp.addr
  end

  attr_reader :tcp, :udp
  private     :tcp, :udp
end end
