require 'equalizer'
require 'virtus'
require_relative 'uuid'

module Kamerling class UUIDEntity
  include Equalizer.new :uuid

  include Virtus.model

  attribute :uuid, String, default: -> * { UUID.new }

  def self.attrs hash = {}
    hash.each { |name, klass| attribute name, klass }
  end

  def self.defaults hash = {}
    hash.each do |name, default|
      warn_off { attribute name, attribute_set[name].type, default: default }
    end
  end

  def to_h
    attributes.map do |key, value|
      value.is_a?(UUIDEntity) ? [key, value.to_h] : [key, value]
    end.to_h
  end
end end
