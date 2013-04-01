require_relative '../spec_helper'

module Kamerling describe Boso do
  describe '#receive' do
    it 'processes the result for a given task' do
      task = MiniTest::Mock.new.expect :result=, nil, [result = double]
      repo = MiniTest::Mock.new.expect :update, nil, [task]
      Boso.new.receive client: double, project: double, repos: { task: repo },
        result: result, task: task
      repo.verify
      task.verify
    end
  end
end end
