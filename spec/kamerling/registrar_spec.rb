require_relative '../spec_helper'

module Kamerling describe Registrar do
  describe '#register' do
    fakes :addr, :client, :project, :repo

    it 'registers that the given client can do the given project' do
      cuuid, puuid = UUID.new, UUID.new
      repos = { Client => { cuuid => client }, Project => { puuid => project },
        Registration => repo }
      Registrar.new.register addr: addr, client_uuid: cuuid,
        project_uuid: puuid, repos: repos
      repo.must_have_received :<<, [Registration[addr: addr, client: client,
        project: project, uuid: anything]]
    end
  end
end end
