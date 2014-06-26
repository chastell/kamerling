require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/registrar'
require_relative '../../lib/kamerling/repo'

module Kamerling describe Registrar do
  describe '#register' do
    fakes :addr, :client, :project, :repo

    let :mess do
      fake :message, client_uuid: client.uuid, project_uuid: project.uuid
    end

    let :repos do
      {
        Client       => { client.uuid  => client  },
        Project      => { project.uuid => project },
        Registration => repo,
      }
    end

    it 'registers that the given client can do the given project' do
      registrar = Registrar.new repos: repos
      registrar.register addr: addr, message: mess, uuid: 'abcd'
      registration = Registration.new addr: addr, client: client,
                                      project: project, uuid: 'abcd'
      repo.must_have_received :<<, [registration]
    end

    it 'doesn’t blow up when a new client tries to register' do
      client_repo = fake :repo, :[] => -> { fail Repo::NotFound }
      repos[Client] = client_repo
      registrar = Registrar.new repos: repos
      registrar.register addr: addr, message: mess, uuid: 'abcd'
      client_repo.must_have_received :<<, [any(Client)]
    end
  end
end end
