require_relative '../spec_helper'

module Kamerling describe '.UUIDObject' do
  describe '.new' do
    it 'creates a class with an UUID property defaulting to a random UUID' do
      AttrLess = Kamerling.UUIDObject
      AttrLess.new.uuid.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
      AttrLess.new.uuid.wont_equal AttrLess.new.uuid
    end

    it 'allows setting custom properties and raises when they lack defaults' do
      FooFul = Kamerling.UUIDObject :foo
      FooFul.new(foo: 'bar').foo.must_equal 'bar'
      -> { FooFul.new }.must_raise RuntimeError
    end

    it 'allows setting properties’ default procs' do
      ProcFul = Kamerling.UUIDObject rand: -> { rand }
      ProcFul.new.rand.wont_equal ProcFul.new.rand
    end

    it 'allows setting properties’ default values' do
      ValFul = Kamerling.UUIDObject bar: :baz
      ValFul.new.bar.must_equal :baz
    end
  end

  describe '#==' do
    it 'reports UUID-based euqality' do
      Actor = Kamerling.UUIDObject :name
      Actor.new(name: :laurel).wont_equal Actor.new(name: :laurel)
      uuid = UUID.new
      Actor.new(name: :laurel, uuid: uuid)
        .must_equal Actor.new(name: :hardy, uuid: uuid)
    end
  end
end end
