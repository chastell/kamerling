require 'gserver'
require 'logger'

module Kamerling class Server
  def initialize(handler: Handler.new, logger: Logger.new('/dev/null'),
                 host: '127.0.0.1', http_port: 0, tcp_port: 0, udp_port: 0)
    @http = HTTP.new host: host, port: http_port
    @tcp = TCP.new handler: handler, host: host, logger: logger, port: tcp_port
    @udp = UDP.new handler: handler, host: host, logger: logger, port: udp_port
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
