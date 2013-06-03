require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :addr, :client, :task

    it 'saves the result and updates client and task' do
      repos = fake :repos, as: :class
      stub(repos).[](Client) { fake :repo, :[] => client }
      stub(repos).[](Task)   { fake :repo, :[] => task   }
      Receiver.new.receive addr: addr, client_uuid: client.uuid, data: 'data',
        repos: repos, task_uuid: task.uuid
      client.must_have_received :busy=, false
      task.must_have_received   :done=, true
      repos.must_have_received :<<, [client]
      repos.must_have_received :<<, [task]
      repos.must_have_received :<<, [Result[addr: addr, client: client,
        data: 'data', task: task, uuid: anything]]
    end
  end
end end
