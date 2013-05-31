require_relative '../spec_helper'

module Kamerling describe UUID do
  describe '.from_bin' do
    it 'creates a normal UUID representation from binary data' do
      UUID.from_bin('16B project UUID')
        .must_equal '31364220-7072-6f6a-6563-742055554944'
    end
  end

  describe '.new' do
    it 'creates a new random UUID' do
      UUID.new.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
      UUID.new.wont_equal UUID.new
    end
  end
end end
