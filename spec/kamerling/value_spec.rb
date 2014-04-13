require_relative '../spec_helper'
require_relative '../../lib/kamerling/value'

module Kamerling describe Value do
  describe '.new' do
    it 'creates a class with value semantics' do
      address = Class.new(Value) { vals street: String }
      address.new(street: 'Folsom').must_equal address.new street: 'Folsom'
      address.new(street: 'Folsom').wont_equal address.new street: 'Fair'
    end
  end

  describe '.vals' do
    it 'allows defining values in a key → class manner' do
      address = Class.new(Value) { vals street: String, country: String }
      address.attribute_set.map(&:name).must_equal %i(street country)
    end
  end
end end
