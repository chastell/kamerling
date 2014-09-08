require_relative '../spec_helper'
require_relative '../../lib/kamerling/registration'

module Kamerling
  describe Registration do
    describe '#registered_at' do
      it 'defaults to the current time' do
        registered_at = Registration.new.registered_at
        assert registered_at.between?(Time.now - 1, Time.now + 1)
      end

      it 'defaults to the time of Registration’s creation' do
        Registration.new.registered_at.wont_equal Registration.new.registered_at
      end
    end
  end
end
