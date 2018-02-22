require 'virtus'

module Kamerling
  class Value
    class << self
      def defaults(hash = {})
        hash.each do |name, default|
          attribute name, attribute_set[name].type, default: default
        end
      end

      def vals(hash = {})
        values { hash.each { |name, klass| attribute name, klass } }
      end
    end

    include Virtus.value_object

    # :reek:FeatureEnvy
    def to_h
      attributes.transform_values { |val| val.is_a?(Symbol) ? val.to_s : val }
    end
  end
end
