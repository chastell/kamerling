require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/dispatch'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/net_dispatcher'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_dispatcher'
require_relative '../../lib/kamerling/uuid'

module Kamerling describe TaskDispatcher do
  let(:addr)           { Addr.new                                              }
  let(:client)         { Client.new addr: addr, uuid: UUID['16B client  UUID'] }
  let(:net_dispatcher) { fake :net_dispatcher, as: :class                      }
  let(:project)        { Project.new uuid: UUID['16B project UUID']            }
  let(:repos)          { fake :repos, as: :class, projects: [project]          }
  let(:task)           { Task.new data: 'data', uuid: UUID['16B task    UUID'] }

  before do
    stub(repos).next_task_for(project) { task }
    stub(repos).free_clients_for(project) { [client] }
    TaskDispatcher.new(net_dispatcher: net_dispatcher, repos: repos).dispatch
  end

  describe '#dispatch' do
    it 'dispatches tasks to free clients' do
      message = Message.build client: client, payload: 'data', project: project,
                              task: task, type: :DATA
      net_dispatcher.must_have_received :dispatch, [addr, message]
    end

    it 'dispatches marks clients as busy' do
      assert client.busy
      repos.must_have_received :<<, [client]
    end

    it 'creates and stores a Dispatch object along the way' do
      TaskDispatcher.new(net_dispatcher: net_dispatcher, repos: repos).dispatch
      repos.must_have_received :<<, [Dispatch.new(uuid: anything)]
    end
  end
end end
