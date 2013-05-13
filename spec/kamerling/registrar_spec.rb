require_relative '../spec_helper'

module Kamerling describe Registrar do
  describe '#register' do
    it 'registers that the given client can do the given project' do
      addr    = fake :addr
      client  = fake :client
      project = fake :project
      repo    = fake :repo
      Registrar.new.register addr: addr, client: client, project: project,
        repos: { Registration => repo }
      repo.must_have_received :<<,
        [{ addr: addr, client: client, project: project }]
    end
  end
end end
