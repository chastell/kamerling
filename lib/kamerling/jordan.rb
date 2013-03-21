require 'gserver'

module Kamerling class Jordan < GServer
  def initialize(handler: nil, host: DEFAULT_HOST, port: 0)
    @handler = handler
    super port, host
    start
  end

  def serve io
    handler.handle io.read
  end

  attr_reader :handler
  private     :handler
end end
