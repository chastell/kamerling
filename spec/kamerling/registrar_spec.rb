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
      Registrar.new.register project_uuid: '16B project UUID',
        client_uuid: '16B client  UUID', client_addr: addr, repos: repos
      repo.must_have_received :<<, [Registration[project, client, addr]]
    end
  end
end end
