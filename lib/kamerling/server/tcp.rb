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

  private

  def handle input, client_addr
    handler.handle input, client_addr
  rescue Handler::UnknownInput
  end

  def handle_connection socket
    client_addr = Addr[*socket.remote_address.ip_unpack, :TCP]
    input       = socket.read
    handle input, client_addr
  ensure
    socket.close
  end

  def run_loop
    Socket.tcp_server_loop(*addr) { |socket| handle_connection socket }
  end
end end end
