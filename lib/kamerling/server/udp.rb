module Kamerling module Server class UDP
  attr_reader :addr

  def initialize addr: req(:addr), handler: Handler.new
    @addr    = addr
    @handler = handler
  end

  def join
    thread.join
  end

  def start
    @thread = Thread.new { run_loop }
    200.times { thread.run }
    self
  end

  def stop
    thread.exit.join
  end

  attr_reader :handler, :thread
  private     :handler, :thread

  private

  def handle_connection socket
    input, conn = socket.recvfrom 2**16
    client_addr = Addr[conn[3], conn[1], :UDP]
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
