module Kamerling class Server::HTTP
  attr_reader :addr

  def initialize addr: req(:addr)
    @addr = addr
  end

  def start
    Thread.new { HTTPAPI.run! bind: addr.host, port: addr.port }
    self
  end

  def stop
    HTTPAPI.quit!
  end
end end
