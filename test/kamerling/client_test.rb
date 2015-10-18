require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'

module Kamerling
  describe Client do
    describe '#busy' do
      it 'defaults to false' do
        refute Client.new.busy
      end
    end

    describe '#new_to_h' do
      it 'returns a Hash representation of the Client' do
        addr   = Addr['127.0.0.1', 1979, :UDP]
        client = Client.new(addr: addr, busy: true, type: :FPGA)
        _(client.new_to_h).must_equal busy: true, host: '127.0.0.1', port: 1979,
                                      prot: 'UDP', type: 'FPGA',
                                      uuid: any(String)
      end
    end
  end
end
