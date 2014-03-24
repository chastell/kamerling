require 'virtus'

module Kamerling class UUIDEntity
  include Equalizer.new :uuid

  include Virtus.model

  attribute :uuid, String, default: -> * { UUID.new }

  class << self
    alias_method :from_h, :new
  end

  alias_method :to_h, :attributes
end end
