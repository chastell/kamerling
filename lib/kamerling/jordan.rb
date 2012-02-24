module Kamerling class Jordan
  module Server
  end

  attr_reader :host, :port

  def initialize args = { host: '127.0.0.1', port: 0 }
    EM.run do
      conn = EM.start_server args[:host], args[:port], Server
      @port, @host = Socket.unpack_sockaddr_in EM.get_sockname conn
    end
  end
end end
