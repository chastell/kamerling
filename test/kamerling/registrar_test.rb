require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/registrar'
require_relative '../../lib/kamerling/repo'

module Kamerling
  describe Registrar do
    describe '.register' do
      let(:addr)    { Addr.new    }
      let(:client)  { Client.new  }
      let(:project) { Project.new }

      let(:mess) { Message.rgst(client: client, project: project) }

      let(:repos) { fake(:repos, as: :class) }

      before do
        stub(repos).[](Client)       { fake(:repo, :[] => client)  }
        stub(repos).[](Project)      { fake(:repo, :[] => project) }
        stub(repos).[](Registration) { fake(:repo)                 }
      end

      it 'registers that the given client can do the given project' do
        Registrar.register addr: addr, message: mess, repos: repos
        _(repos).must_have_received :<<, [any(Registration)]
      end

      it 'updates the clien’t addr' do
        Registrar.register addr: addr, message: mess, repos: repos
        _(repos).must_have_received :<<, [client]
      end

      it 'doesn’t blow up when a new client tries to register' do
        empty_repo = fake(:repo, :[] => -> { fail Repo::NotFound })
        stub(repos).[](Client) { empty_repo }
        Registrar.register addr: addr, message: mess, repos: repos
        _(repos).must_have_received :<<, [client]
      end
    end
  end
end
