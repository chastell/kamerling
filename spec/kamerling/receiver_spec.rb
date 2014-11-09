require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/receiver'
require_relative '../../lib/kamerling/repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/result'
require_relative '../../lib/kamerling/task'

module Kamerling
  describe Receiver do
    describe '.receive' do
      it 'saves the result and updates client and task' do
        addr   = Addr.new
        client = Client.new(busy: true)
        task   = Task.new(done: false)
        repos  = fake(:repos, as: :class)
        stub(repos).<<(any_args) { repos }
        stub(repos).[](Client)   { fake(:repo, :[] => client) }
        stub(repos).[](Task)     { fake(:repo, :[] => task)   }
        message = Message.build(client: client, payload: 'data',
                                project: Project.new, task: task, type: :RSLT)
        Receiver.receive addr: addr, message: message, repos: repos
        refute client.busy
        assert task.done
        repos.must_have_received :<<, [client]
        repos.must_have_received :<<, [any(Result)]
        repos.must_have_received :<<, [task]
      end
    end
  end
end
