# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/dispatch'
require_relative '../../lib/kamerling/dispatch_repo'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/net_dispatcher'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_dispatcher'
require_relative '../../lib/kamerling/task_repo'
require_relative '../../lib/kamerling/uuid'

module Kamerling
  describe TaskDispatcher do
    let(:addr)           { Addr.new                                     }
    let(:client)         { Client.new(addr: addr)                       }
    let(:client_repo)    { fake(ClientRepo, free_for_project: [client]) }
    let(:dispatch_repo)  { fake(DispatchRepo)                           }
    let(:net_dispatcher) { fake(NetDispatcher, as: :class)              }
    let(:project)        { Project.new                                  }
    let(:project_repo)   { fake(ProjectRepo, all: [project])            }
    let(:task)           { Task.new(data: 'data')                       }
    let(:task_repo)      { fake(TaskRepo, next_for_project: task)       }

    let(:repos) do
      fake(Repos, client_repo: client_repo, dispatch_repo: dispatch_repo,
                  project_repo: project_repo, task_repo: task_repo)
    end

    before do
      td = TaskDispatcher.new(net_dispatcher: net_dispatcher, repos: repos)
      td.dispatch_all
    end

    describe '#dispatch_all' do
      it 'dispatches tasks to free clients' do
        bytes = Message.data(client: client, project: project, task: task).to_s
        _(net_dispatcher).must_have_received :dispatch, [bytes, addr: addr]
      end

      it 'marks clients as busy and persists the change' do
        assert client.busy
        _(client_repo).must_have_received :<<, [client]
      end

      it 'creates and stores a Dispatch object along the way' do
        _(dispatch_repo).must_have_received :<<, [any(Dispatch)]
      end
    end
  end
end
