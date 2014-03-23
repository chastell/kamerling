require 'virtus'

module Kamerling class UUIDEntity
  include Virtus.model

  attribute :uuid, String, default: -> * { UUID.new }

  class << self
    alias from_h new
  end
end end
