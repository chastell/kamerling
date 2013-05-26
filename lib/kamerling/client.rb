module Kamerling
  Client = Struct.new :addr, :uuid do
    def initialize host: nil, port: nil, addr: Addr[host, port], uuid: raise
      super addr, uuid
    end

    def to_h
      super.tap do |hash|
        hash.merge! host: addr.host, port: addr.port
        hash.delete :addr
      end
    end
  end
end
