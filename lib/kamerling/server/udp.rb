module Kamerling class Server::UDP
  attr_reader :addr

  def initialize addr: req(:addr), handler: Handler.new,
                 logger: Logger.new('/dev/null')
    @addr    = addr
    @handler = handler
    @logger  = logger
  end

  def start
    logger.info "start #{addr}"
    @socket = UDPSocket.new.tap { |server| server.bind(*addr) }
    @thread = Thread.new do
      run_select_loop
    end
    self
  end

  def stop
    thread.exit
    socket.close
  end

  attr_reader :handler, :logger, :socket, :thread
  private     :handler, :logger, :socket, :thread

  private

  def run_select_loop
    loop do
      if IO.select [socket]
        input, conn = socket.recvfrom 2**16
        client_addr = Addr[conn[3], conn[1], :UDP]
        logger.info "connect #{client_addr}"
        logger.debug "received #{client_addr} #{input}"
        handler.handle input, client_addr
      end
    end
  end
end end
