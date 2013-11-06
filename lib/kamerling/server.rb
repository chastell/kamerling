require 'gserver'
require 'logger'

module Kamerling class Server
  def initialize addrs: req(:addrs), logger: Logger.new('/dev/null'),
                 servers: nil
    @servers = servers || {
      http: HTTP.new(addr: addrs[:http]),
      tcp:  TCP.new(addr: addrs[:tcp], logger: logger),
      udp:  UDP.new(addr: addrs[:udp], logger: logger),
    }
  end

  def join
    servers[:tcp].join
  end

  def start
    servers.values.each(&:start)
    self
  end

  def http_addr
    servers[:http].addr
  end

  def stop
    servers.values.each(&:stop)
  end

  def tcp_addr
    servers[:tcp].addr
  end

  def udp_addr
    servers[:udp].addr
  end

  attr_reader :servers
  private     :servers
end end
