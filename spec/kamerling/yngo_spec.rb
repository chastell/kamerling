require_relative '../spec_helper'

module Kamerling describe Yngo do
  describe '#register' do
    it 'registers that the given client can do the given project' do
      repo = MiniTest::Mock.new.expect :<<, nil,
        [Registration.new(client = double, project = double)]
      repos = { registration: repo }
      Yngo.new.register client: client, project: project, repos: repos
      repo.verify
    end
  end
end end
