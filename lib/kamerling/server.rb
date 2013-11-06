require 'gserver'
require 'logger'

module Kamerling class Server
  def initialize(handler: Handler.new, logger: Logger.new('/dev/null'),
                 host: '127.0.0.1', http_port: 0, tcp_port: 0, udp_port: 0)
    http_addr = Addr[host, http_port, :TCP]
    @http = HTTP.new addr: http_addr
    tcp_addr = Addr[host, tcp_port, :TCP]
    @tcp = TCP.new addr: tcp_addr, handler: handler, logger: logger
    udp_addr = Addr[host, udp_port, :UDP]
    @udp = UDP.new addr: udp_addr, handler: handler, logger: logger
  end

  def join
    tcp.join
  end

  def start
    http.start
    tcp.start
    udp.start
    self
  end

  def http_addr
    http.addr
  end

  def stop
    http.stop
    tcp.stop
    udp.stop
  end

  def tcp_addr
    tcp.addr
  end

  def udp_addr
    udp.addr
  end

  attr_reader :http, :tcp, :udp
  private     :http, :tcp, :udp
end end
