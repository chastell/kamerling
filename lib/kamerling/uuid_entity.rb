require 'virtus'

module Kamerling class UUIDEntity
  include Equalizer.new :uuid

  include Virtus.model

  attribute :uuid, String, default: -> * { UUID.new }

  class << self
    alias from_h new
  end
end end
