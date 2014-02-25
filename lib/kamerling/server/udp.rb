module Kamerling module Server class UDP < Sock
  def start
    @thread = Thread.new { run_loop }
    200.times { thread.run }
    self
  end

  private

  def handle_connection socket
    input, conn = socket.recvfrom 2**16
    client_addr = Addr[conn[3], conn[1], :UDP]
    handle input, client_addr
  end

  def run_loop
    socket = UDPSocket.new.tap { |server| server.bind(*addr) }
    loop { handle_connection socket if IO.select [socket] }
  ensure
    socket.close if socket
  end
end end end
