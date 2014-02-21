module Kamerling module Server class TCP
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
    loop { break if addr.connectable? }
    self
  end

  def stop
    thread.exit.join
  end

  attr_reader :handler, :thread
  private     :handler, :thread

  def handle_connection socket
    c_addr = Addr[*socket.remote_address.ip_unpack, :TCP]
    input  = socket.read
    handler.handle input, c_addr
  rescue Handler::UnknownInput
  ensure
    socket.close
  end

  def run_loop
    Socket.tcp_server_loop(*addr) { |socket| handle_connection socket }
  end
end end end
