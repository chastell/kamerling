require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :addr, :client, :repo, :task
    let(:repos) { {
      Client => { '16B client  UUID' => client },
      Result => repo,
      Task   => { '16B task    UUID' => task   },
    } }

    it 'processes the result for a given task' do
      Receiver.new.receive client_addr: addr, client_uuid: '16B client  UUID',
        data: 'data', repos: repos, task_uuid: '16B task    UUID'
      repo.must_have_received :<<, [Result[client, addr, task, 'data']]
    end
  end
end end
