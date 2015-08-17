require_relative '../test_helper'
require_relative '../../lib/kamerling/uuid'

module Kamerling
  describe UUID do
    describe '.[]' do
      it 'creates a normal UUID representation from binary data' do
        uuid = '31364220-7072-6f6a-6563-742055554944'
        _(UUID['16B project UUID']).must_equal uuid
      end
    end

    describe '.bin' do
      it 'returns the binary representation of an UUID' do
        uuid = UUID.bin('31364220-7072-6f6a-6563-742055554944')
        _(uuid).must_equal '16B project UUID'
      end
    end

    describe '.new' do
      it 'creates a new random UUID' do
        _(UUID.new).must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
        _(UUID.new).wont_equal UUID.new
      end
    end
  end
end
