require 'gserver'

module Kamerling class Server < GServer
  def initialize handler: Handler.new, host: DEFAULT_HOST, port: 0
    @handler = handler
    super port, host
  end

  def start
    start_udp_server
    super
  end

  def tcp_addr
    Addr[host, port, 'TCP']
  end

  def udp_addr
    Addr[host, port, 'UDP']
  end

  attr_reader :handler
  private     :handler

  private

  def serve io
    handler.handle io.read, Addr[*io.remote_address.ip_unpack, 'TCP']
  end

  def start_udp_server
    Thread.new do
      udp_server = UDPSocket.new
      udp_server.bind host, port
      loop do
        if IO.select [udp_server]
          input, conn = udp_server.recvfrom(2**16)
          handler.handle input, Addr[conn[3], conn[1], 'UDP']
        end
      end
    end
  end
end end
