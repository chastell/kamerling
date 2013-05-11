require_relative '../spec_helper'

module Kamerling describe Receiver do
  describe '#receive' do
    it 'processes the result for a given task' do
      repo = MiniTest::Mock.new.expect :<<, nil,
        [{ client: client = fake, data: data = fake, task: task = fake }]
      Receiver.new.receive client: client, data: data, repos: { results: repo },
        task: task
      repo.verify
    end
  end
end end
