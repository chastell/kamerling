require_relative '../spec_helper'

module Kamerling describe Client do
  describe '.from_h' do
    it 'backtranslates host and port to addr' do
      uuid = UUID.from_bin '16B client  UUID'
      Client.from_h(host: '127.0.0.1', port: 1981, uuid: uuid)
        .addr.must_equal Addr['127.0.0.1', 1981]
    end
  end

  describe '#to_h' do
    it 'represents addr as a host + port pair' do
      uuid = UUID.from_bin '16B client  UUID'
      hash = Client[addr: Addr['127.0.0.1', 1981], uuid: uuid].to_h
      hash[:host].must_equal '127.0.0.1'
      hash[:port].must_equal 1981
    end
  end
end end
