# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/entity'

module Kamerling
  describe Entity do
    describe '.attrs' do
      it 'allows defining attributes in a key → class manner' do
        person = Class.new(Entity) { attrs name: String, born: Integer }
        _(person.attribute_set.map(&:name)).must_equal %i(id name born)
      end
    end

    describe '.defaults' do
      it 'allows defining attribute defaults' do
        song = Class.new(Entity) do
          attrs title: String, genre: Symbol
          defaults genre: :ragga
        end
        _(song.new.genre).must_equal :ragga
      end
    end

    describe '.new' do
      it 'creates a class with an id property defaulting to a random UUID' do
        attr_less = Class.new(Entity)
        _(attr_less.new.id).must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
        _(attr_less.new.id).wont_equal attr_less.new.id
      end

      it 'deserialises the object from a Hash' do
        trivial = Class.new(Entity) { attrs question: Symbol }
        _(trivial.new(question: :answer).question).must_equal :answer
      end
    end

    describe '.null' do
      it 'returns a new entity with an all-zero UUID' do
        nullable = Class.new(Entity)
        _(nullable.null.id).must_equal '00000000-0000-0000-0000-000000000000'
      end
    end

    describe '#==' do
      it 'reports all-attribute-based euqality' do
        actor = Class.new(Entity) { attrs name: Symbol }
        _(actor.new(name: :laurel)).wont_equal actor.new(name: :laurel)
        id     = UUID.new
        laurel = actor.new(id: id, name: :laurel)
        hardy  = actor.new(id: id, name: :hardy)
        _(laurel).wont_equal hardy
      end
    end

    describe '#to_h' do
      it 'serialises the object to a Hash' do
        hashble = Class.new(Entity) { attrs param: Symbol }
        hash = hashble.new(param: 'val').to_h
        _(hash).must_equal id: any(String), param: 'val'
      end

      it 'serialises Symbols to Strings' do
        symbolic  = Class.new(Entity) { attrs symbol: Symbol }
        valentine = symbolic.new(symbol: :♥)
        _(valentine.to_h).must_equal id: valentine.id, symbol: '♥'
      end

      it 'serialises Times to UTC, ISO 8601' do
        timely  = Class.new(Entity) { attrs happened_at: Time }
        arrival = timely.new(happened_at: Time.parse('2014-12-23 05:00+01'))
        _(arrival.to_h).must_equal happened_at: '2014-12-23T04:00:00Z',
                                   id: arrival.id
      end

      it 'keeps only related Entities’ ids' do
        Child  = Class.new(Entity) { attrs name: String }
        Parent = Class.new(Entity) { attrs child: Child, name: String }
        zosia  = Child.new(name: 'Zosia')
        marta  = Parent.new(child: zosia, name: 'Marta')
        marta_hash = { child_id: zosia.id, id: marta.id, name: 'Marta' }
        _(marta.to_h).must_equal marta_hash
      end

      it 'embeds related Values' do
        addr   = Class.new(Value) { vals host: String, port: Integer }
        client = Class.new(Entity) { attrs addr: addr, name: String }
        home   = addr.new(host: 'localhost', port: 1981)
        unit   = client.new(addr: home, name: 'sweet')
        _(unit.to_h).must_equal host: 'localhost', id: unit.id, name: 'sweet',
                                port: 1981
      end
    end
  end
end
