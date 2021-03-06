require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/registrar'
require_relative '../../lib/kamerling/repos'

module Kamerling
  describe Registrar do
    describe '.call' do
      let(:addr)         { Addr.new                                           }
      let(:client_repo)  { fake(ClientRepo, fetch: old_client)                }
      let(:mess)         { Message.rgst(client: old_client, project: project) }
      let(:old_client)   { Client.new                                         }
      let(:project)      { Project.new                                        }
      let(:updtd_client) { old_client.update(addr: addr)                      }

      let(:repos) do
        project_repo = fake(ProjectRepo, fetch: project)
        fake(Repos, client_repo: client_repo, project_repo: project_repo)
      end

      it 'records the registration' do
        Registrar.call addr: addr, message: mess, repos: repos
        params = [{ addr: addr, client: updtd_client, project: project }]
        _(repos).must_have_received :record_registration, params
      end

      it 'updates the client’s addr' do
        Registrar.call addr: addr, message: mess, repos: repos
        _(client_repo).must_have_received :<<, [updtd_client]
      end
    end
  end
end
