module Kamerling class Client < UUIDEntity
  attribute :addr, Addr
  attribute :busy, Boolean, default: false

  def self.from_h hash
    super.tap do |client|
      client.addr = Addr[hash[:host], hash[:port], hash[:prot]]
    end
  end

  def to_h
    super.reject { |key, _| key == :addr }.merge addr.to_h
  end
end end
