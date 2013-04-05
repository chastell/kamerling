require_relative '../spec_helper'

module Kamerling describe Yngo do
  describe '#register' do
    it 'registers that the given client can do the given project' do
      registration = Yngo::Registration.new addrinfo = double,
        client = double, project = double
      repo = MiniTest::Mock.new.expect :<<, nil, [registration]
      repos = { registrations: repo }
      Yngo.new.register addrinfo: addrinfo, client: client, project: project,
        repos: repos
      repo.verify
    end
  end
end end
