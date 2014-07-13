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
    let(:addr)    { Addr.new    }
    let(:client)  { Client.new  }
    let(:project) { Project.new }

    let :mess do
      Message.build client: client, payload: 'data', project: project,
                    task: Task.new, type: :RGST
    end

    let(:registrar) { Registrar.new repos: repos }

    let :repos do
      {
        Client       => fake(:repo, :[] => client),
        Project      => fake(:repo, :[] => project),
        Registration => fake(:repo),
      }
    end

    it 'registers that the given client can do the given project' do
      registrar.register addr: addr, message: mess, uuid: 'abcd'
      registration = Registration.new addr: addr, client: client,
                                      project: project, uuid: 'abcd'
      repos[Registration].must_have_received :<<, [registration]
    end

    it 'updates the clien’t addr' do
      registrar.register addr: addr, message: mess, uuid: 'abcd'
      repos[Client].must_have_received :<<, [any(Client)]
    end

    it 'doesn’t blow up when a new client tries to register' do
      repos[Client] = fake :repo, :[] => -> { fail Repo::NotFound }
      registrar.register addr: addr, message: mess, uuid: 'abcd'
      repos[Client].must_have_received :<<, [any(Client)]
    end
  end
end end
