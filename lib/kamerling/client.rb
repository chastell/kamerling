module Kamerling class Client < UUIDEntity
  attribute :addr, Addr
  attribute :busy, Boolean, default: false
end end
