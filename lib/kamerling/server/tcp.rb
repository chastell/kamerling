module Kamerling class Server::TCP
  attr_reader :addr

  def initialize addr: req(:addr), handler: Handler.new,
                 logger: Logger.new('/dev/null')
    @addr    = addr
    @handler = handler
    @logger  = logger
  end

  def start
    logger.info "start #{addr}"
    @thread = Thread.new do
      Socket.tcp_server_loop(*addr) do |socket|
        handle_connection socket
      end
    end
    self
  end

  def stop
    thread.exit
  end

  attr_reader :handler, :logger, :thread
  private     :handler, :logger, :thread

  def handle_connection socket
    c_addr = Addr[*socket.remote_address.ip_unpack, :TCP]
    input  = socket.read
    logger.info "connect #{c_addr}"
    logger.debug "received #{c_addr} #{input}"
    handler.handle input, c_addr
  end
end end
