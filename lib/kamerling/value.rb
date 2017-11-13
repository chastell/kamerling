require 'virtus'

module Kamerling
  class Value
    include Virtus.value_object

    def self.defaults(hash = {})
      hash.each do |name, default|
        attribute name, attribute_set[name].type, default: default
      end
    end

    def self.vals(hash = {})
      values { hash.each { |name, klass| attribute name, klass } }
    end

    def to_h
      attributes.map { |key, val| { key => serialise(val) } }.reduce(:merge)
    end

    private

    # :reek:UtilityFunction
    def serialise(value)
      value.is_a?(Symbol) ? value.to_s : value
    end
  end
end
