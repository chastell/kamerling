require_relative '../spec_helper'

module Kamerling describe Registrar do
  describe '#register' do
    fakes :addr, :client, :project, :repo
    let(:repos) { {
      Client       => { '16B client  UUID' => client  },
      Project      => { '16B project UUID' => project },
      Registration => repo,
    } }

    it 'registers that the given client can do the given project' do
      Registrar.new.register addr: addr, client_uuid: '16B client  UUID',
        project_uuid: '16B project UUID', repos: repos
      repo.must_have_received :<<,
        [Registration[addr: addr, client: client, project: project]]
    end
  end
end end
