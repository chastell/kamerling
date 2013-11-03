module Kamerling class Server::HTTP
  def initialize host: '127.0.0.1', port: 0
    @host, @port = host, port
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
