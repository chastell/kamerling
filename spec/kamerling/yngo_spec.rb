require_relative '../spec_helper'

module Kamerling describe Yngo do
  describe '#register' do
    it 'registers that the given client can do the given project' do
      repo = MiniTest::Mock.new
      repo.expect :<<, nil, [{ addrinfo: addrinfo = double,
        client: client = double, project: project = double }]
      repos = { registrations: repo }
      Yngo.new.register addrinfo: addrinfo, client: client, project: project,
        repos: repos
      repo.verify
    end
  end
end end
