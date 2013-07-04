require 'gserver'

module Kamerling class Server < GServer
  def initialize handler: Handler.new, host: DEFAULT_HOST, tcp_port: 0
    @handler = handler
    super tcp_port, host
  end

  def start
    start_udp_server
    super
    @tcp_port = port
    self
  end

  def tcp_addr
    Addr[host, tcp_port, 'TCP']
  end

  def udp_addr
    Addr[host, udp_port, 'UDP']
  end

  attr_reader :handler, :tcp_port, :udp_port
  private     :handler, :port, :tcp_port, :udp_port

  private

  def serve io
    handler.handle io.read, Addr[*io.remote_address.ip_unpack, 'TCP']
  end

  def start_udp_server
    Thread.new do
      udp_server = UDPSocket.new
      udp_server.bind host, 0
      @udp_port = udp_server.addr[1]
      loop do
        if IO.select [udp_server]
          input, conn = udp_server.recvfrom 2**16
          handler.handle input, Addr[conn[3], conn[1], 'UDP']
        end
      end
    end
  end
end end
