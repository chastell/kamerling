require 'gserver'

module Kamerling class Server < GServer
  def initialize handler: Handler.new, host: DEFAULT_HOST, port: 0
    @handler = handler
    super port, host
  end

  def addr
    Addr[host, port, 'TCP']
  end

  attr_reader :handler
  private     :handler

  private

  def serve io
    handler.handle io.read, Addr[*io.remote_address.ip_unpack, 'TCP']
  end
end end
