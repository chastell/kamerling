require_relative '../spec_helper'

module Kamerling describe Registration do
  fakes :addr, :client, :project

  describe '.from_h' do
    it 'backtranslates client_uuid, host, port and project_uuid' do
      addr  = Addr['127.0.0.1', 1981]
      repos = { Client => { client.uuid => client },
        Project => { project.uuid => project } }
      hash = { client_uuid: client.uuid, host: addr.host, port: addr.port,
        project_uuid: project.uuid }
      Registration.from_h(hash, repos).must_equal Registration[addr: addr,
        client: client, project: project, uuid: anything]
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
      registration = Registration[addr: addr, client: client, project: project]
      registration.to_h.must_equal({ client_uuid: client.uuid, host: addr.host,
        port: addr.port, project_uuid: project.uuid, uuid: registration.uuid })
    end
  end
end end
