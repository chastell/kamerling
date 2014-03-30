require 'virtus'

module Kamerling class UUIDEntity
  include Equalizer.new :uuid

  include Virtus.model

  attribute :uuid, String, default: -> * { UUID.new }

  alias_method :to_h, :attributes
end end
