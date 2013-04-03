require 'gserver'

module Kamerling class Jordan < GServer
  def initialize(handler: Franchus.new, host: DEFAULT_HOST, port: 0)
    @handler = handler
    super port, host
    start
  end

  def serve io
    handler.handle io.read, io.remote_address
  end

  attr_reader :handler
  private     :handler
end end
