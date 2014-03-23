require_relative '../spec_helper'

module Kamerling describe UUIDEntity do
  describe '.from_h' do
    it 'deserialises the object from a Hash' do
      Trivial = Class.new(UUIDEntity) { attribute :question, Symbol }
      Trivial.from_h(question: :answer).question.must_equal :answer
    end
  end
end end
