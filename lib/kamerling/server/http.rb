module Kamerling class Server::HTTP
  attr_reader :addr

  def initialize addr: req(:addr)
    @addr = addr
  end

  def start
    @thread = Thread.new { HTTPAPI.run! bind: addr.host, port: addr.port }
    loop { break if connectable? }
    self
  end

  def stop
    thread.exit.join
  end

  attr_reader :thread
  private     :thread

  def connectable?
    TCPSocket.open(*addr).close
    true
  rescue Errno::ECONNREFUSED
    false
  end
end end
