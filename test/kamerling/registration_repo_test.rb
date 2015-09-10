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

    describe '#<<' do
      it 'adds a new Registration to the repo' do
        db = Sequel.sqlite
        path = "#{__dir__}/../../lib/kamerling/migrations"
        Sequel::Migrator.run db, path
        repo = RegistrationRepo.new(db)
        assert db[:registrations].empty?
        addr    = Addr['localhost', 1981, :TCP]
        client  = Client.new(addr: addr, busy: true, type: :FPGA, uuid: 'cUUID')
        project = Project.new(name: 'GIMPS', uuid: 'pUUID')
        db[:clients] << Mapper.to_h(client)
        db[:projects] << Mapper.to_h(project)
        registration = Registration.new(addr: addr, client: client,
                                        project: project, uuid: 'rUUID')
        repo << registration
        _(db[:registrations].first).must_equal client_uuid: 'cUUID',
                                               host: 'localhost', port: 1981,
                                               project_uuid: 'pUUID',
                                               prot: 'TCP',
                                               registered_at: any(Time),
                                               uuid: 'rUUID'
      end
    end
  end
end
