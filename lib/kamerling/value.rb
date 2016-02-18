# frozen_string_literal: true

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
      values do
        hash.each { |name, klass| attribute name, klass }
      end
    end
  end
end
