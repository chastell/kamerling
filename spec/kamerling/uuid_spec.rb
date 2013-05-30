require_relative '../spec_helper'

module Kamerling describe UUID do
  describe '.new' do
    it 'creates a new random UUID' do
      UUID.new.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
      UUID.new.wont_equal UUID.new
    end
  end
end end
