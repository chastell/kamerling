require_relative '../spec_helper'

module Kamerling describe '.UUIDObject' do
  it 'creates a class with an UUID property defaulting to a random UUID' do
    AttrLess = Kamerling.UUIDObject
    AttrLess.new.uuid.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
    AttrLess.new.uuid.wont_equal AttrLess.new.uuid
  end
end end
