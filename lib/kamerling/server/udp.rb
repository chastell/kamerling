module Kamerling module Server class UDP
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
    200.times { thread.run }
    self
  end

  def stop
    thread.exit.join
  end

  attr_reader :handler, :logger, :thread
  private     :handler, :logger, :thread

  private

  def handle_connection socket
    input, conn = socket.recvfrom 2**16
    client_addr = Addr[conn[3], conn[1], :UDP]
    logger.info "connect #{client_addr}"
    logger.debug "received #{client_addr} #{input}"
    handler.handle input, client_addr
  rescue Handler::UnknownInput
  end

  def run_loop
    socket = UDPSocket.new.tap { |server| server.bind(*addr) }
    loop { handle_connection socket if IO.select [socket] }
  ensure
    socket.close
  end
end end end
