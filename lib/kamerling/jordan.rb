module Kamerling class Jordan
  module Server
  end

  def initialize args
    @host, @port = args[:host], args[:port]
  end

  def start
    EM.run { EM.start_server @host, @port, Server }
  end
end end
