# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/receiver'
require_relative '../../lib/kamerling/result'
require_relative '../../lib/kamerling/result_repo'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'

module Kamerling
  describe Receiver do
    describe '.receive' do
      it 'saves the result and updates client and task' do
        addr        = Addr.new
        client      = Client.new(busy: true)
        client_repo = fake(ClientRepo, fetch: client)
        result_repo = fake(ResultRepo)
        task        = Task.new(done: false, project: Project.new)
        task_repo   = fake(TaskRepo, fetch: task)
        message = Message.rslt(client: client, payload: 'data', task: task)
        Receiver.receive addr: addr, client_repo: client_repo, message: message,
                         result_repo: result_repo, task_repo: task_repo
        refute client.busy
        assert task.done
        _(client_repo).must_have_received :<<, [client]
        _(result_repo).must_have_received :<<, [any(Result)]
        _(task_repo).must_have_received :<<, [task]
      end
    end
  end
end
