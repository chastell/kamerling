module Kamerling class Server::UDP
  def initialize handler: Handler.new, host: '127.0.0.1',
                 logger: Logger.new('/dev/null'), port: req(:port)
    @handler = handler
    @host    = host
    @logger  = logger
    @port    = port
  end

  def addr
    Addr[host, port, :UDP]
  end

  def start
    logger.info "start #{addr}"
    @socket = UDPSocket.new.tap { |server| server.bind host, port }
    @thread = Thread.new do
      run_select_loop
    end
    self
  end

  def stop
    thread.exit
    socket.close
  end

  attr_reader :handler, :host, :logger, :port, :socket, :thread
  private     :handler, :host, :logger, :port, :socket, :thread

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
