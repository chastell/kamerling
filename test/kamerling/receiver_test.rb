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
        client      = Client.new(busy: true)
        client_repo = fake(ClientRepo, fetch: client)
        task        = Task.new(done: false, project: Project.new)
        task_repo   = fake(TaskRepo, fetch: task)
        repos       = fake(Repos, client_repo: client_repo,
                                  task_repo:   task_repo)
        message = Message.rslt(client: client, data: 'data', task: task)
        Receiver.call addr: addr, message: message, repos: repos
        refute client.busy
        assert task.done
        params = [{ addr: addr, client: client, data: 'data', task: task }]
        _(repos).must_have_received :record_result, params
        _(client_repo).must_have_received :<<, [client]
        _(task_repo).must_have_received :<<, [task]
      end
    end
  end
end
