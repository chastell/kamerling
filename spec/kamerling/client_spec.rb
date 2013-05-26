require_relative '../spec_helper'

module Kamerling describe Client do
  describe '.new' do
    it 'can be instantiated with host and port' do
      client = Client[host: '127.0.0.1', port: 1981, uuid: '16B client  UUID']
      client.addr.must_equal Addr['127.0.0.1', 1981]
    end
  end

  describe '#to_h' do
    it 'represents addr as a host + port pair' do
      addr = Addr['127.0.0.1', 1981]
      uuid = '16B client  UUID'
      Client[addr: addr, uuid: uuid].to_h
        .must_equal({ host: '127.0.0.1', port: 1981, uuid: '16B client  UUID' })
    end
  end
end end
