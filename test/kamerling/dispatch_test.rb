require_relative '../test_helper'
require_relative '../../lib/kamerling/dispatch'

module Kamerling
  describe Dispatch do
    describe '#dispatched_at' do
      it 'defaults to the current time' do
        assert Dispatch.new.dispatched_at.between?(Time.now - 1, Time.now + 1)
      end

      it 'defaults to the time of Dispatch’s creation' do
        _(Dispatch.new.dispatched_at).wont_equal Dispatch.new.dispatched_at
      end
    end
  end
end
