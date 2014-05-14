require_relative '../spec_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
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
      message = fake :message, client_uuid: client.uuid,
                               project_uuid: project.uuid
      registrar = Registrar.new repos: repos
      registrar.register addr: addr, message: message, uuid: 'abcd'
      registration = Registration.new addr: addr, client: client,
                                      project: project, uuid: 'abcd'
      repo.must_have_received :<<, [registration]
    end
  end
end end
