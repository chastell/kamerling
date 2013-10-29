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
    logger.info "connect #{Addr[*client.remote_address.ip_unpack, :TCP]}"
    true
  end

  def disconnecting *_
  end

  def serve io
    addr  = Addr[*io.remote_address.ip_unpack, :TCP]
    input = io.read
    logger.debug "received #{addr} #{input}"
    handler.handle input, addr
  end

  def start_udp_server
    logger.info "start #{udp_addr}"
    Thread.new do
      loop do
        if IO.select [udp_server]
          input, conn = udp_server.recvfrom 2**16
          addr = Addr[conn[3], conn[1], :UDP]
          logger.info "connect #{addr}"
          logger.debug "received #{addr} #{input}"
          handler.handle input, addr
        end
      end
    end
  end

  def starting
    logger.info "start #{tcp_addr}"
  end

  def stopping
  end

  class NullLogger
    def debug _
    end

    def info _
    end
  end
end end
