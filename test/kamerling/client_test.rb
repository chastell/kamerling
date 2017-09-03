# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/udp_addr'

module Kamerling
  describe Client do
    describe '#busy' do
      it 'defaults to false' do
        refute Client.new.busy
      end
    end

    describe '#to_h' do
      it 'returns a Hash representation of the Client' do
        addr   = UDPAddr['127.0.0.1', 1979]
        client = Client.new(addr: addr, busy: true, type: :FPGA)
        _(client.to_h).must_equal busy: true, host: '127.0.0.1',
                                  id: any(String), port: 1979, prot: 'UDP',
                                  type: 'FPGA'
      end
    end
  end
end
