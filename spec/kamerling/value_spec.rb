require_relative '../spec_helper'

module Kamerling describe Value do
  describe '.new' do
    it 'creates a class with value semantics' do
      Address = Class.new(Value) { values { attribute :street, String } }
      Address.new(street: 'Folsom').must_equal Address.new street: 'Folsom'
      Address.new(street: 'Folsom').wont_equal Address.new street: 'Fair'
    end
  end
end end
