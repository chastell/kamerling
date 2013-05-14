require_relative '../spec_helper'

module Kamerling describe Registrar do
  describe '#register' do
    fakes :addr, :client, :project, :repo

    it 'registers that the given client can do the given project' do
      Registrar.new.register addr: addr, client: client, project: project,
        repos: { Registration => repo }
      repo.must_have_received :<<,
        [{ addr: addr, client: client, project: project }]
    end
  end
end end
