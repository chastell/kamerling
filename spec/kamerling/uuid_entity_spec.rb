require_relative '../spec_helper'

module Kamerling describe UUIDEntity do
  describe '.from_h' do
    it 'deserialises the object from a Hash' do
      Trivial = Class.new(UUIDEntity) { attribute :question, Symbol }
      Trivial.from_h(question: :answer).question.must_equal :answer
    end
  end

  describe '.new' do
    it 'creates a class with an UUID property defaulting to a random UUID' do
      AttrLess = Class.new UUIDEntity
      AttrLess.new.uuid.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
      AttrLess.new.uuid.wont_equal AttrLess.new.uuid
    end
  end

  describe '#==' do
    it 'reports UUID-based euqality' do
      Actor = Class.new(UUIDEntity) { attribute :name, Symbol }
      Actor.new(name: :laurel).wont_equal Actor.new name: :laurel
      uuid = UUID.new
      Actor.new(name: :laurel, uuid: uuid)
        .must_equal Actor.new name: :hardy, uuid: uuid
    end
  end
end end
