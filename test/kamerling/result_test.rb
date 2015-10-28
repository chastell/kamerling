require_relative '../test_helper'
require_relative '../../lib/kamerling/result'

module Kamerling
  describe Result do
    describe '#received_at' do
      it 'defaults to the current time' do
        assert Result.new.received_at.between?(Time.now - 1, Time.now + 1)
      end

      it 'defaults to the time of Result’s creation' do
        _(Result.new.received_at).wont_equal Result.new.received_at
      end

      it 'is in UTC' do
        _(Result.new.received_at.zone).must_equal 'UTC'
      end
    end
  end
end
