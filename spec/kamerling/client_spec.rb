require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'

module Kamerling
  describe Client do
    describe '#busy' do
      it 'defaults to false' do
        refute Client.new.busy
      end
    end
  end
end
