require_relative '../spec_helper'

module Kamerling describe '.UUIDObject' do
  it 'creates a class with an UUID property defaulting to a random UUID' do
    AttrLess = Kamerling.UUIDObject
    AttrLess.new.uuid.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
    AttrLess.new.uuid.wont_equal AttrLess.new.uuid
  end

  it 'allows setting custom properties and raises when they default to nil' do
    FooFul = Kamerling.UUIDObject foo: nil
    FooFul.new(foo: 'bar').foo.must_equal 'bar'
    -> { FooFul.new }.must_raise RuntimeError
  end

  it 'allows setting properties’ default procs' do
    ProcFul = Kamerling.UUIDObject rand: -> { rand }
    ProcFul.new.rand.wont_equal ProcFul.new.rand
  end
end end
