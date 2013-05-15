require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    fakes :client, :repo, :task

    it 'processes the result for a given task' do
      Receiver.new.receive client: client, data: 'data',
        repos: { Result => repo }, task: task
      repo.must_have_received :<<, [Result[client, task, 'data']]
    end
  end
end end
