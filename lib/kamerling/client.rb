require_relative 'addr'
require_relative 'entity'

module Kamerling
  class Client < Entity
    vals addr: Addr, busy: Boolean, type: Symbol
    defaults busy: false
  end
end
