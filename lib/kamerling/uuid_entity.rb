require 'equalizer'
require 'virtus'
require_relative 'uuid'

module Kamerling class UUIDEntity
  include Equalizer.new :uuid

  include Virtus.model

  attribute :uuid, String, default: -> * { UUID.new }

  alias_method :to_h, :attributes

  def self.attrs hash = {}
    hash.each { |name, klass| attribute name, klass }
  end

  def self.defaults hash = {}
    hash.each do |name, default|
      warn_off { attribute name, attribute_set[name].type, default: default }
    end
  end
end end
