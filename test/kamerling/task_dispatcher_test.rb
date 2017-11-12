require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
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
    let(:addr)           { Addr.new                                         }
    let(:old_client)     { Client.new(addr: addr)                           }
    let(:client)         { old_client.update(busy: true)                    }
    let(:client_repo)    { fake(ClientRepo, free_for_project: [old_client]) }
    let(:net_dispatcher) { fake(NetDispatcher, as: :class)                  }
    let(:project)        { Project.new                                      }
    let(:project_repo)   { fake(ProjectRepo, all: [project])                }
    let(:task)           { Task.new(data: 'data')                           }
    let(:task_repo)      { fake(TaskRepo, next_for_project: task)           }

    let(:repos) do
      fake(Repos, client_repo: client_repo, project_repo: project_repo,
                  task_repo: task_repo)
    end

    before do
      td = TaskDispatcher.new(net_dispatcher: net_dispatcher, repos: repos)
      td.dispatch_all
    end

    describe '#dispatch_all' do
      it 'dispatches tasks to free clients' do
        mess = Message.data(client: old_client, project: project, task: task)
        _(net_dispatcher).must_have_received :dispatch, [mess.to_s, addr: addr]
      end

      it 'marks clients as busy and persists the change' do
        _(client_repo).must_have_received :mark_busy, [{ id: client.id }]
      end

      it 'records the dispatch' do
        params = [{ client: client, project: project, task: task }]
        _(repos).must_have_received :record_dispatch, params
      end
    end
  end
end
