require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/registrar'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/registration_repo'

module Kamerling
  describe Registrar do
    describe '.register' do
      let(:addr)              { Addr.new                                       }
      let(:client)            { Client.new                                     }
      let(:client_repo)       { fake(ClientRepo, fetch: client)                }
      let(:mess)              { Message.rgst(client: client, project: project) }
      let(:project)           { Project.new                                    }
      let(:project_repo)      { fake(ProjectRepo, fetch: project)              }
      let(:registration_repo) { fake(RegistrationRepo)                         }

      let(:repos) do
        fake(:repos, as: :class, client_repo: client_repo,
                     project_repo: project_repo,
                     registration_repo: registration_repo)
      end

      it 'registers that the given client can do the given project' do
        Registrar.register addr: addr, message: mess, repos: repos
        _(registration_repo).must_have_received :<<, [any(Registration)]
      end

      it 'updates the client’s addr' do
        Registrar.register addr: addr, message: mess, repos: repos
        _(client_repo).must_have_received :<<, [client]
      end
    end
  end
end
