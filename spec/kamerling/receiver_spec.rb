require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :addr, :client, :repo, :task
    let(:repos) { {
      Client => { UUID.from_bin('16B client  UUID') => client },
      Result => repo,
      Task   => { UUID.from_bin('16B task    UUID') => task   },
    } }

    it 'processes the result for a given task' do
      Receiver.new.receive addr: addr,
        client_uuid: UUID.from_bin('16B client  UUID'), data: 'data',
        repos: repos, task_uuid: UUID.from_bin('16B task    UUID')
      repo.must_have_received :<<,
        [Result[addr: addr, client: client, data: 'data', task: task]]
    end
  end
end end
