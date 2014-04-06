module Kamerling class Client < UUIDEntity
  attrs addr: Addr
  attribute :busy, Boolean, default: false
end end
