# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/receiver'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'

module Kamerling
  describe Receiver do
    describe '.call' do
      it 'saves the result and updates client and task' do
        addr        = Addr.new
        old_client  = Client.new(busy: true)
        client      = old_client.update(busy: false)
        client_repo = fake(ClientRepo, fetch: old_client)
        old_task    = Task.new(done: false)
        project     = Project.new
        task        = old_task.update(done: true)
        task_repo   = fake(TaskRepo, fetch: old_task)
        repos       = fake(Repos, client_repo: client_repo,
                                  task_repo:   task_repo)
        message = Message.rslt(client: old_client, data: 'data',
                               project: project, task: old_task)
        Receiver.call addr: addr, message: message, repos: repos
        params = [{ addr: addr, client: client, data: 'data', task: task }]
        _(repos).must_have_received :record_result, params
        _(client_repo).must_have_received :mark_free, [{ id: client.id }]
        _(task_repo).must_have_received :mark_done, [{ id: task.id }]
      end
    end
  end
end
