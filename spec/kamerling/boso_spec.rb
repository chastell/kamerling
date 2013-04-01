require_relative '../spec_helper'

module Kamerling describe Boso do
  describe '#receive' do
    it 'processes the result for a given task' do
      repo = MiniTest::Mock.new.expect :add, nil, [{ client: client = double,
        data: data = double, task: task = double }]
      Boso.new.receive client: client, data: data, repos: { result: repo },
        task: task
      repo.verify
    end
  end
end end
