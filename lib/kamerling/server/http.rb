module Kamerling class Server::HTTP
  def initialize host: '127.0.0.1', port: req(:port)
    @host, @port = host, port
  end

  def addr
    Addr[host, port, :TCP]
  end

  def start
    Thread.new { HTTPAPI.run! bind: host, port: port }
    self
  end

  def stop
    HTTPAPI.quit!
  end

  attr_reader :host, :port
  private     :host, :port
end end
