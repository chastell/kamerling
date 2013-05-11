require_relative '../spec_helper'

module Kamerling describe Registrar do
  describe '#register' do
    it 'registers that the given client can do the given project' do
      repo = MiniTest::Mock.new.expect :<<, nil,
        [{ addr: addr = fake, client: client = fake, project: project = fake }]
      repos = { registrations: repo }
      Registrar.new
        .register addr: addr, client: client, project: project, repos: repos
      repo.verify
    end
  end
end end
