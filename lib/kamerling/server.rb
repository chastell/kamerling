require 'gserver'
require 'logger'

module Kamerling class Server
  def initialize addrs: req(:addrs), logger: Logger.new('/dev/null'),
                 servers: servers_from(addrs, logger)
    @servers = servers
  end

  def start
    servers.values.each(&:start)
    self
  end

  def stop
    servers.values.each(&:stop)
  end

  attr_reader :servers
  private     :servers

  private

  def servers_from addrs, logger
    {
      http: HTTP.new(addr: addrs[:http]),
      tcp:  TCP.new(addr: addrs[:tcp], logger: logger),
      udp:  UDP.new(addr: addrs[:udp], logger: logger),
    }
  end
end end
