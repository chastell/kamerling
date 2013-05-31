require_relative '../spec_helper'

module Kamerling describe Registration do
  before { Repos.db = Sequel.sqlite }

  fakes :addr, :client, :project

  describe '.from_h' do
    it 'backtranslates client_uuid, host, port and project_uuid' do
      addr = Addr['127.0.0.1', 1981]
      Repos << client  = Client[addr: addr, uuid: cuuid = UUID.new]
      Repos << project = Project[name: 'project name', uuid: puuid = UUID.new]
      reg = Registration.from_h client_uuid: cuuid, host: '127.0.0.1',
        port: 1981, project_uuid: puuid
      reg.must_equal Registration[addr: addr, client: client, project: project,
        uuid: anything]
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
    it 'serialises addr, client and project' do
      hash = Registration[addr: addr, client: client, project: project].to_h
      hash.must_equal({ client_uuid: client.uuid, host: addr.host,
        port: addr.port, project_uuid: project.uuid, uuid: anything })
    end
  end
end end
