require_relative 'addr'
require_relative 'entity'

module Kamerling
  class Client < Entity
    attrs addr: Addr, busy: Boolean, type: Symbol
    defaults busy: false

    def to_h
      attributes.merge(type: type.to_s)
    end
  end
end
