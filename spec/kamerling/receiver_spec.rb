require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :addr, :client, :repo, :task

    it 'processes the result for a given task' do
      repos = { Client => { client.uuid => client }, Result => repo,
        Task => { task.uuid => task } }
      Receiver.new.receive addr: addr, client_uuid: client.uuid, data: 'data',
        repos: repos, task_uuid: task.uuid
      repo.must_have_received :<<, [Result[addr: addr, client: client,
        data: 'data', task: task, uuid: anything]]
    end
  end
end end
