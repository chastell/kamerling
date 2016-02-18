# frozen_string_literal: true

require_relative 'addr'
require_relative 'entity'

module Kamerling
  class Client < Entity
    attrs addr: Addr, busy: Boolean, type: Symbol
    defaults busy: false

    def new_to_h
      addr.to_h.merge(busy: busy, type: type.to_s, uuid: uuid)
    end

    def to_h
      attributes.merge(type: type.to_s)
    end
  end
end
