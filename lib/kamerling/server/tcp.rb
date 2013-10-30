module Kamerling class Server::TCP < GServer
  def initialize handler: Handler.new, host: '127.0.0.1',
                 logger: Logger.new('/dev/null'), port: 0
    super port, host
    @audit   = true
    @handler = handler
    @logger  = logger
  end

  def addr
    Addr[host, port, :TCP]
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
