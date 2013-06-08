module Kamerling class Client < UUIDObject :addr, busy: false
  def self.from_h hash
    hash.merge! addr: Addr[hash[:host], hash[:port]]
    hash.delete :host
    hash.delete :port
    new hash
  end
end end
