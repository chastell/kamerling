require_relative '../test_helper'
require_relative '../../lib/kamerling/uuid_entity'

module Kamerling
  describe UUIDEntity do
    describe '.attrs' do
      it 'allows defining attributes in a key → class manner' do
        person = Class.new(UUIDEntity) { attrs name: String, born: Integer }
        person.attribute_set.map(&:name).must_equal %i(uuid name born)
      end
    end

    describe '.defaults' do
      it 'allows defining attribute defaults' do
        song = Class.new(UUIDEntity) do
          attrs title: String, genre: Symbol
          defaults genre: :ragga
        end
        song.new.genre.must_equal :ragga
      end
    end

    describe '.new' do
      it 'creates a class with an UUID property defaulting to a random UUID' do
        attr_less = Class.new(UUIDEntity)
        attr_less.new.uuid.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
        attr_less.new.uuid.wont_equal attr_less.new.uuid
      end

      it 'deserialises the object from a Hash' do
        trivial = Class.new(UUIDEntity) { attrs question: Symbol }
        trivial.new(question: :answer).question.must_equal :answer
      end
    end

    describe '#==' do
      it 'reports UUID-based euqality' do
        actor = Class.new(UUIDEntity) { attrs name: Symbol }
        actor.new(name: :laurel).wont_equal actor.new(name: :laurel)
        uuid = UUID.new
        actor.new(name: :laurel, uuid: uuid)
          .must_equal actor.new(name: :hardy, uuid: uuid)
      end
    end

    describe '#to_h' do
      it 'serialises the object to a Hash' do
        hashble = Class.new(UUIDEntity) { attrs param: Symbol }
        hashble.new(param: :val).to_h.must_equal param: :val, uuid: any(String)
      end

      it 'serialises related UUIDEntities' do
        child  = Class.new(UUIDEntity) { attrs name: String }
        parent = Class.new(UUIDEntity) { attrs child: child, name: String }
        zosia  = child.new(name: 'Zosia')
        marta  = parent.new(child: zosia, name: 'Marta')
        zosia_hash = { name: 'Zosia', uuid: zosia.uuid }
        marta_hash = { child: zosia_hash, name: 'Marta', uuid: marta.uuid }
        marta.to_h.must_equal marta_hash
      end
    end
  end
end
