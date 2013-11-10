module Kamerling class Server::HTTP
  attr_reader :addr

  def initialize addr: req(:addr)
    @addr = addr
  end

  def start
    @thread = Thread.new do
      Rack::Handler::WEBrick.run HTTPAPI, Host: addr.host, Port: addr.port
    end
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
