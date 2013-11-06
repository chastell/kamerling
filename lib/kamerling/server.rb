require 'gserver'
require 'logger'

module Kamerling class Server
  def initialize addrs: req(:addrs), handler: Handler.new,
                 logger: Logger.new('/dev/null')
    @http = HTTP.new addr: addrs[:http]
    @tcp  = TCP.new  addr: addrs[:tcp], handler: handler, logger: logger
    @udp  = UDP.new  addr: addrs[:udp], handler: handler, logger: logger
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
