require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :addr, :client, :task
    let(:client_repo) { fake :repo, :[] => client }
    let(:result_repo) { fake :repo }
    let(:task_repo)   { fake :repo, :[] => task   }
    let(:repos) {
      { Client => client_repo, Result => result_repo, Task => task_repo }
    }

    it 'saves the result and updates client and task' do
      Receiver.new.receive addr: addr, client_uuid: client.uuid, data: 'data',
        repos: repos, task_uuid: task.uuid
      client.must_have_received :busy=, false
      task.must_have_received   :done=, true
      client_repo.must_have_received :<<, [client]
      task_repo.must_have_received   :<<, [task]
      result_repo.must_have_received :<<, [Result[addr: addr, client: client,
        data: 'data', task: task, uuid: anything]]
    end
  end
end end
