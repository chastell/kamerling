module Kamerling class UUIDEntity
  include Equalizer.new :uuid

  include Virtus.model

  attribute :uuid, String, default: -> * { UUID.new }

  alias_method :to_h, :attributes

  def self.attrs hash = {}
    hash.each { |name, klass| attribute name, klass }
  end
end end
