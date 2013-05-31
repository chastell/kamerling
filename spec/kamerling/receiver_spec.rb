require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :addr, :client, :repo, :task
    let(:cuuid) { UUID.new }
    let(:tuuid) { UUID.new }
    let(:repos) { {
      Client => { cuuid => client }, Result => repo, Task => { tuuid => task },
    } }

    it 'processes the result for a given task' do
      Receiver.new.receive addr: addr, client_uuid: cuuid, data: 'data',
        repos: repos, task_uuid: tuuid
      repo.must_have_received :<<,
        [Result[addr: addr, client: client, data: 'data', task: task]]
    end
  end
end end
