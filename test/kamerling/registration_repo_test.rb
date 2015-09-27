require 'sequel'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/mapper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/registration_repo'

module Kamerling
  describe RegistrationRepo do
    Sequel.extension :migration

    let(:addr) { Addr['localhost', 1981, :TCP] }
    let(:client) do
      Client.new(addr: addr, busy: true, type: :FPGA, uuid: 'cUUID')
    end
    let(:db) { Sequel.sqlite }
    let(:entity) do
      Registration.new(addr: addr, client: client, project: project,
                       uuid: 'rUUID')
    end
    let(:project) { Project.new(name: 'GIMPS', uuid: 'pUUID') }
    let(:row) do
      { client_uuid: 'cUUID', host: 'localhost', port: 1981,
        project_uuid: 'pUUID', prot: 'TCP', registered_at: any(Time),
        uuid: 'rUUID' }
    end
    let(:repo) { RegistrationRepo.new(db) }
    let(:table) { db[:registrations] }

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
      db[:clients] << Mapper.to_h(client)
      db[:projects] << Mapper.to_h(project)
    end

    describe '#<<' do
      it 'adds a new Registration to the repo' do
        assert table.empty?
        repo << entity
        _(table.first).must_equal row
      end
    end
  end
end
