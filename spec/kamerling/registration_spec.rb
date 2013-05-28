require_relative '../spec_helper'

module Kamerling describe Registration do
  fakes :addr, :client, :project

  describe '.new' do
    it 'gives the registration a random UUID' do
      r1 = Registration[addr: addr, client: client, project: project]
      r2 = Registration[addr: addr, client: client, project: project]
      r1.uuid.wont_equal r2.uuid
    end
  end

  describe '#to_h' do
    it 'represents addr as a host + port pair' do
      addr = Addr['127.0.0.1', 1981]
      hash = Registration[addr: addr, client: client, project: project].to_h
      hash[:host].must_equal '127.0.0.1'
      hash[:port].must_equal 1981
    end
  end
end end
