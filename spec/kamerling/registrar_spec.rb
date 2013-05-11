require_relative '../spec_helper'

module Kamerling describe Registrar do
  describe '#register' do
    it 'registers that the given client can do the given project' do
      repo = MiniTest::Mock.new
      repo.expect :<<, nil, [{ addrinfo: addrinfo = fake,
        client: client = fake, project: project = fake }]
      repos = { registrations: repo }
      Registrar.new.register addrinfo: addrinfo, client: client, project: project,
        repos: repos
      repo.verify
    end
  end
end end
