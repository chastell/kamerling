require 'gserver'

module Kamerling class Jordan < GServer
  def initialize(host: DEFAULT_HOST, port: 0)
    super port, host
    start
  end
end end
