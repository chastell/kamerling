require 'gserver'

module Kamerling class Server < GServer
  def initialize handler: Handler.new, host: DEFAULT_HOST, tcp_port: 0, udp_port: 0
    @handler = handler
    super tcp_port, host
    @udp_server = UDPSocket.new.tap { |s| s.bind host, udp_port }
  end

  def start
    start_udp_server
    super
  end

  def tcp_addr
    Addr[host, port, 'TCP']
  end

  def udp_addr
    Addr[host, udp_server.addr[1], 'UDP']
  end

  attr_reader :handler, :udp_server
  private     :handler, :udp_server
  private     :host, :port

  private

  def serve io
    handler.handle io.read, Addr[*io.remote_address.ip_unpack, 'TCP']
  end

  def start_udp_server
    Thread.new do
      loop do
        if IO.select [udp_server]
          input, conn = udp_server.recvfrom 2**16
          handler.handle input, Addr[conn[3], conn[1], 'UDP']
        end
      end
    end
  end
end end
