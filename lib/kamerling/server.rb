module Kamerling class Server
  def initialize addrs: req(:addrs), logger: Logger.new('/dev/null'),
                 servers: servers_from(addrs, logger)
    @servers = servers
  end

  def join
    servers.each(&:join)
  end

  def start
    servers.each(&:start)
    self
  end

  def stop
    servers.each(&:stop)
  end

  attr_reader :servers
  private     :servers

  private

  def servers_from addrs, logger
    [
      HTTP.new(addr: addrs[:http]),
      TCP.new(addr: addrs[:tcp], logger: logger),
      UDP.new(addr: addrs[:udp], logger: logger),
    ]
  end
end end
