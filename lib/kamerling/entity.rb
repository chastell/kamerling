# frozen_string_literal: true

require 'virtus'
require_relative 'uuid'
require_relative 'value'

module Kamerling
  class Entity < Value
    values { attribute :id, String, default: -> (*) { UUID.new } }

    def self.attrs(hash = {})
      values { hash.each { |name, klass| attribute name, klass } }
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

    def update(values)
      self.class.new(attributes.merge(values))
    end

    private

    def id_key(value)
      "#{value.class.name.split('::').last.downcase}_id".to_sym
    end
  end
end
