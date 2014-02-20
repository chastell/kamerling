module Kamerling module Server class TCP
  attr_reader :addr

  def initialize addr: req(:addr), handler: Handler.new,
                 logger: Logger.new('/dev/null')
    @addr    = addr
    @handler = handler
    @logger  = logger
  end

  def join
    thread.join
  end

  def start
    logger.info "start #{addr}"
    @thread = Thread.new { run_loop }
    loop { break if addr.connectable? }
    self
  end

  def stop
    thread.exit.join
  end

  attr_reader :handler, :logger, :thread
  private     :handler, :logger, :thread

  def handle_connection socket
    c_addr = Addr[*socket.remote_address.ip_unpack, :TCP]
    input  = socket.read
    logger.info "connect #{c_addr}"
    logger.debug "received #{c_addr} #{input}"
    handler.handle input, c_addr
  ensure
    socket.close
  end

  def run_loop
    Socket.tcp_server_loop(*addr) { |socket| handle_connection socket }
  end
end end end
