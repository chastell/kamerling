require 'virtus'

module Kamerling class UUIDEntity
  include Virtus.model

  class << self
    alias from_h new
  end
end end
