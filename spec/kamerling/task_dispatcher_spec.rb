require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/net_dispatcher'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_dispatcher'
require_relative '../../lib/kamerling/uuid'

module Kamerling describe TaskDispatcher do
  describe '#dispatch' do
    it 'dispatches tasks to free clients and marks them as busy' do
      addr    = fake :addr
      client  = fake :client, addr: addr, uuid: UUID['16B client  UUID']
      project = fake :project, uuid: UUID['16B project UUID']
      task    = fake :task, data: 'data', uuid: UUID['16B task    UUID']
      repos   = fake :repos, as: :class, projects: [project]
      stub(repos).next_task_for(project) { task }
      stub(repos).free_clients_for(project) { [client] }
      net_dispatcher = fake :net_dispatcher, as: :class

      TaskDispatcher.new(net_dispatcher: net_dispatcher, repos: repos).dispatch

      message = Message[client: client, payload: 'data', project: project,
                        task: task, type: 'DATA']
      net_dispatcher.must_have_received :dispatch, [addr, message]
      client.must_have_received :busy=, [true]
      repos.must_have_received :<<, [client]
    end
  end
end end
