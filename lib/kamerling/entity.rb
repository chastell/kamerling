# frozen_string_literal: true

require_relative 'uuid'
require_relative 'value'

module Kamerling
  class Entity < Value
    vals id: String
    defaults id: -> (*) { UUID.new }

    def self.null
      new(id: UUID.zero)
    end

    def to_h
      attributes.map(&method(:hashify)).reduce({}, :merge)
    end

    def update(values)
      self.class.new(attributes.merge(values))
    end

    private

    def hashify((key, value))
      case value
      when Symbol then { key => value.to_s }
      when Time   then { key => value.utc.iso8601 }
      when Value  then value.to_h
      else { key => value }
      end
    end
  end
end
