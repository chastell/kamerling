require_relative '../spec_helper'
require_relative '../../lib/kamerling/registrar'

module Kamerling describe Registrar do
  describe '#register' do
    fakes :addr, :client, :project, :repo

    it 'registers that the given client can do the given project' do
      repos = {
        Client       => { client.uuid  => client  },
        Project      => { project.uuid => project },
        Registration => repo,
      }
      Registrar.new.register addr: addr, client_uuid: client.uuid,
                             project_uuid: project.uuid, repos: repos
      registration = Registration.new addr: addr, client: client,
                                      project: project, uuid: anything
      repo.must_have_received :<<, [registration]
    end
  end
end end
