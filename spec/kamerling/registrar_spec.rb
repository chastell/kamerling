require_relative '../spec_helper'

module Kamerling describe Registrar do
  describe '#register' do
    fakes :addr, :client, :project, :repo
    let(:repos) { {
      Client       => { UUID.from_bin('16B client  UUID') => client  },
      Project      => { UUID.from_bin('16B project UUID') => project },
      Registration => repo,
    } }

    it 'registers that the given client can do the given project' do
      reg = Registrar.new
      reg.register addr: addr, client_uuid: UUID.from_bin('16B client  UUID'),
        project_uuid: UUID.from_bin('16B project UUID'), repos: repos
      repo.must_have_received :<<, [Registration[addr: addr, client: client,
        project: project, uuid: anything]]
    end
  end
end end
