# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/entity'

module Kamerling
  describe Entity do
    describe '.attrs' do
      it 'allows defining attributes in a key → class manner' do
        person = Class.new(Entity) { attrs name: String, born: Integer }
        _(person.attribute_set.map(&:name)).must_equal %i(uuid name born)
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
      it 'creates a class with an UUID property defaulting to a random UUID' do
        attr_less = Class.new(Entity)
        _(attr_less.new.uuid).must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
        _(attr_less.new.uuid).wont_equal attr_less.new.uuid
      end

      it 'deserialises the object from a Hash' do
        trivial = Class.new(Entity) { attrs question: Symbol }
        _(trivial.new(question: :answer).question).must_equal :answer
      end
    end

    describe '.null' do
      it 'returns a new entity with an all-zero UUID' do
        nullable = Class.new(Entity)
        _(nullable.null.uuid).must_equal '00000000-0000-0000-0000-000000000000'
      end
    end

    describe '#==' do
      it 'reports UUID-based euqality' do
        actor = Class.new(Entity) { attrs name: Symbol }
        _(actor.new(name: :laurel)).wont_equal actor.new(name: :laurel)
        uuid = UUID.new
        laurel = actor.new(name: :laurel, uuid: uuid)
        hardy  = actor.new(name: :hardy,  uuid: uuid)
        _(laurel).must_equal hardy
      end
    end

    describe '#to_h' do
      it 'serialises the object to a Hash' do
        hashble = Class.new(Entity) { attrs param: Symbol }
        hash = hashble.new(param: :val).to_h
        _(hash).must_equal param: :val, uuid: any(String)
      end

      it 'serialises related UUIDEntities' do
        child  = Class.new(Entity) { attrs name: String }
        parent = Class.new(Entity) { attrs child: child, name: String }
        zosia  = child.new(name: 'Zosia')
        marta  = parent.new(child: zosia, name: 'Marta')
        zosia_hash = { name: 'Zosia', uuid: zosia.uuid }
        marta_hash = { child: zosia_hash, name: 'Marta', uuid: marta.uuid }
        _(marta.to_h).must_equal marta_hash
      end
    end
  end
end
