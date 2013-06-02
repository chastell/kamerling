require 'gserver'

module Kamerling class Server < GServer
  def initialize handler: Handler.new, host: DEFAULT_HOST, port: 0
    @handler = handler
    super port, host
    start
  end

  def addr
    Addr[host, port]
  end

  def serve io
    handler.handle io.read, Addr[*io.remote_address.ip_unpack]
  end

  attr_reader :handler
  private     :handler
end end
