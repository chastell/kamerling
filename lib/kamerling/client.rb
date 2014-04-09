module Kamerling class Client < UUIDEntity
  attrs addr: Addr, busy: Boolean
  defaults busy: false
end end
