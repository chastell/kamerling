require_relative '../spec_helper'

module Kamerling describe Client do
  describe '.from_h' do
    it 'backtranslates host and port to addr' do
      Client.from_h(host: '127.0.0.1', port: 1981, uuid: '16B client  UUID')
        .must_equal Client[addr: Addr['127.0.0.1', 1981],
          uuid: '16B client  UUID']
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
