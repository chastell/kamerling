require_relative '../test_helper'
require_relative '../../lib/kamerling/value'

module Kamerling
  describe Value do
    describe '.defaults' do
      it 'allows defining attribute defaults' do
        address = Class.new(Value) do
          vals city: String
          defaults city: 'Ess-Eff'
        end
        _(address.new.city).must_equal 'Ess-Eff'
      end
    end

    describe '.new' do
      it 'creates a class with value semantics' do
        address = Class.new(Value) { vals street: String }
        folsom = address.new(street: 'Folsom')
        _(folsom).must_equal address.new(street: 'Folsom')
        _(folsom).wont_equal address.new(street: 'Fair')
      end
    end

    describe '.vals' do
      it 'allows defining values in a key → class manner' do
        address = Class.new(Value) { vals street: String, country: String }
        _(address.attribute_set.map(&:name)).must_equal %i[street country]
      end
    end

    describe '#to_h' do
      it 'serialises Symbols to Strings' do
        addr = Class.new(Value) { vals host: String, prot: Symbol }
        localhost = addr.new(host: 'localhost', prot: :UDP)
        _(localhost.to_h).must_equal host: 'localhost', prot: 'UDP'
      end
    end
  end
end
