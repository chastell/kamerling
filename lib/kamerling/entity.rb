# frozen_string_literal: true

require 'equalizer'
require 'virtus'
require_relative 'uuid'

module Kamerling
  class Entity
    include Equalizer.new(:attributes)

    include Virtus.model

    attribute :id, String, default: -> (*) { UUID.new }

    def self.attrs(hash = {})
      hash.each { |name, klass| attribute name, klass }
    end

    def self.defaults(hash = {})
      hash.each do |name, default|
        attribute name, attribute_set[name].type, default: default
      end
    end

    def self.null
      new(id: '00000000-0000-0000-0000-000000000000')
    end

    def to_h
      attributes.map do |(key, value)|
        case value
        when Entity then { id_key(value) => value.id }
        when Symbol then { key => value.to_s }
        when Time   then { key => value.utc.iso8601 }
        when Value  then value.to_h
        else { key => value }
        end
      end.reduce({}, :merge)
    end

    private

    def id_key(value)
      "#{value.class.name.split('::').last.downcase}_id".to_sym
    end
  end
end
