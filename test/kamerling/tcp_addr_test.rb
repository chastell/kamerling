require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/tcp_addr'

module Kamerling
  describe TCPAddr do
    describe '.[]' do
      it 'creates a TCP Addr from the given string' do
        _(TCPAddr['localhost', 1981]).must_equal Addr['localhost', 1981, :TCP]
      end
    end
  end
end
