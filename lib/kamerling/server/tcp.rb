module Kamerling module Server class TCP < Sock
  def start
    @thread = Thread.new { run_loop }
    loop { break if addr.connectable? }
    self
  end

  private

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
