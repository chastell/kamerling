module Kamerling class Client < UUIDObject addr: nil, busy: false
  def self.from_h hash
    hash.merge! addr: Addr[hash[:host], hash[:port]]
    hash.delete :host
    hash.delete :port
    new hash
  end

  def to_h
    super.tap do |hash|
      hash.merge! host: addr.host, port: addr.port
      hash.delete :addr
    end
  end
end end
