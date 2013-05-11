require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    it 'processes the result for a given task' do
      client = fake :client
      repo   = fake :repo
      task   = fake :task
      Receiver.new.receive client: client, data: 'data',
        repos: { results: repo }, task: task
      repo.must_have_received :<<,
        [{ client: client, data: 'data', task: task }]
    end
  end
end end
