require_relative '../spec_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/receiver'
require_relative '../../lib/kamerling/result'
require_relative '../../lib/kamerling/task'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :addr, :client, :task

    it 'saves the result and updates client and task' do
      repos = fake :repos, as: :class
      stub(repos).<<(any_args) { repos }
      stub(repos).[](Client)   { fake :repo, :[] => client }
      stub(repos).[](Task)     { fake :repo, :[] => task   }
      message  = fake :message, client_uuid: client.uuid, payload: 'data',
                                task_uuid: task.uuid
      receiver = Receiver.new repos: repos
      receiver.receive addr: addr, message: message, uuid: 'abcd'
      result = Result.new addr: addr, client: client, data: 'data', task: task,
                          uuid: 'abcd'
      client.must_have_received :busy=, [false]
      task.must_have_received   :done=, [true]
      repos.must_have_received  :<<,    [client]
      repos.must_have_received  :<<,    [task]
      repos.must_have_received  :<<,    [result]
    end
  end
end end
