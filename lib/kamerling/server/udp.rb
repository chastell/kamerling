module Kamerling module Server class UDP < Sock
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

  def wait_till_started
    200.times { thread.run }
  end
end end end
