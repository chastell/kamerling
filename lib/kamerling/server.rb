require 'gserver'
require 'logger'

module Kamerling class Server < GServer
  def initialize(handler: Handler.new, host: DEFAULT_HOST,
                 logger: NullLogger.new, tcp_port: 0, udp_port: 0)
    super tcp_port, host
    @audit      = true
    @handler    = handler
    @logger     = logger
    @udp_server = UDPSocket.new.tap { |server| server.bind host, udp_port }
  end

  def start
    @udp_server_thread = start_udp_server
    super
  end

  def tcp_addr
    Addr[host, port, :TCP]
  end

  def udp_addr
    Addr[udp_server.addr[3], udp_server.addr[1], :UDP]
  end

  attr_reader :handler, :logger, :udp_server
  private     :handler, :logger, :udp_server
  private     :host, :port

  private

  def connecting client
    addr = Addr[*client.remote_address.ip_unpack, :TCP]
    logger.info "TCP connect #{addr.host}:#{addr.port}"
    true
  end

  def starting
    logger.info "TCP start #{tcp_addr.host}:#{tcp_addr.port}"
  end

  def serve io
    handler.handle io.read, Addr[*io.remote_address.ip_unpack, :TCP]
  end

  def start_udp_server
    logger.info "UDP start #{udp_addr.host}:#{udp_addr.port}"
    Thread.new do
      loop do
        if IO.select [udp_server]
          input, conn = udp_server.recvfrom 2**16
          addr = Addr[conn[3], conn[1], :UDP]
          logger.info "UDP connect #{addr.host}:#{addr.port}"
          handler.handle input, addr
        end
      end
    end
  end

  class NullLogger
    def info *; end
  end
end end
