require 'virtus'

module Kamerling
  class Value
    include Virtus.value_object

    def self.vals hash = {}
      values do
        hash.each { |name, klass| attribute name, klass }
      end
    end
  end
end
