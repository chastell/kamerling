require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/mapper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/registration_repo'
require_relative 'new_repo_behaviour'

module Kamerling
  describe RegistrationRepo do
    include NewRepoBehaviour

    Sequel.extension :migration

    let(:addr)    { Addr['localhost', 1981, :TCP]             }
    let(:db)      { Sequel.sqlite                             }
    let(:project) { Project.new(name: 'GIMPS', uuid: 'pUUID') }
    let(:repo)    { RegistrationRepo.new(db)                  }
    let(:table)   { db[:registrations]                        }

    let(:client) do
      Client.new(addr: addr, busy: true, type: :FPGA, uuid: 'cUUID')
    end

    let(:entity) do
      Registration.new(addr: addr, client: client, project: project,
                       registered_at: Time.new('2015-01-01'), uuid: 'an UUID')
    end

    let(:row) do
      { client_uuid: 'cUUID', host: 'localhost', port: 1981,
        project_uuid: 'pUUID', prot: 'TCP',
        registered_at: Time.new('2015-01-01'), uuid: 'an UUID' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
      db[:clients] << Mapper.to_h(client)
      db[:projects] << Mapper.to_h(project)
    end
  end
end
