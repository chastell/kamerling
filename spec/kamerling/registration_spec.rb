require_relative '../spec_helper'

module Kamerling describe Registration do
  fakes :addr, :client, :project

  describe '.from_h' do
    it 'backtranslates host and port to addr' do
      Registration.from_h(client: client, host: '127.0.0.1', port: 1981,
         project: project).addr.must_equal Addr['127.0.0.1', 1981]
    end
  end

  describe '.new' do
    it 'gives the registration a random UUID' do
      r1 = Registration[addr: addr, client: client, project: project]
      r2 = Registration[addr: addr, client: client, project: project]
      r1.uuid.wont_equal r2.uuid
    end
  end

  describe '#to_h' do
    it 'represents addr as a host + port pair' do
      addr   = Addr['127.0.0.1', 1981]
      client = fake :client, uuid: UUID.from_bin('16B client  UUID')
      hash   = Registration[addr: addr, client: client, project: project].to_h
      hash[:client_uuid].must_equal UUID.from_bin('16B client  UUID')
      hash[:host].must_equal '127.0.0.1'
      hash[:port].must_equal 1981
    end
  end
end end
