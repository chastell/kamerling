require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/udp_addr'

module Kamerling
  describe UDPAddr do
    describe '.[]' do
      it 'creates an UDP Addr from the given string' do
        _(UDPAddr['localhost', 1979]).must_equal Addr['localhost', 1979, :UDP]
      end
    end
  end
end
