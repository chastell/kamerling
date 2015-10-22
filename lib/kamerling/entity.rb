require 'equalizer'
require 'virtus'
require_relative 'uuid'

module Kamerling
  class Entity
    include Equalizer.new(:uuid)

    include Virtus.model

    attribute :uuid, String, default: -> (*) { UUID.new }

    def self.attrs(hash = {})
      hash.each { |name, klass| attribute name, klass }
    end

    def self.defaults(hash = {})
      hash.each do |name, default|
        attribute name, attribute_set[name].type, default: default
      end
    end

    def self.null
      new(uuid: '00000000-0000-0000-0000-000000000000')
    end

    def to_h
      attributes.map do |key, value|
        value.is_a?(Entity) ? [key, value.to_h] : [key, value]
      end.to_h
    end
  end
end