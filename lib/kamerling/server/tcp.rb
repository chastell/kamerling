module Kamerling class Server::TCP < GServer
  attr_reader :addr

  def initialize addr: req(:addr), handler: Handler.new,
                 logger: Logger.new('/dev/null')
    super addr.port, addr.host
    @addr    = addr
    @audit   = true
    @handler = handler
    @logger  = logger
  end

  attr_reader :handler, :logger
  private     :handler, :logger

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
    logger.info "start #{addr}"
  end

  def stopping
  end
end end
