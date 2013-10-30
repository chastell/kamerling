require 'gserver'
require 'logger'

module Kamerling class Server < GServer
  def initialize(handler: Handler.new, host: DEFAULT_HOST,
                 logger: Logger.new('/dev/null'), tcp_port: 0, udp_port: 0)
    super tcp_port, host
    @audit      = true
    @handler    = handler
    @logger     = logger
    @udp_server = UDP.new handler: handler, host: host, logger: logger,
      port: udp_port
  end

  def start
    udp_server.start
    super
  end

  def tcp_addr
    Addr[host, port, :TCP]
  end

  def udp_addr
    udp_server.addr
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

  def starting
    logger.info "start #{tcp_addr}"
  end

  def stopping
  end
end end
