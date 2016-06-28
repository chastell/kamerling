# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/registration_repo'
require_relative 'repo_behaviour'

module Kamerling
  describe RegistrationRepo do
    include RepoBehaviour

    Sequel.extension :migration

    let(:addr)    { Addr['localhost', 1981, :TCP]         }
    let(:db)      { Sequel.sqlite                         }
    let(:project) { Project.new(id: 'pid', name: 'GIMPS') }
    let(:repo)    { RegistrationRepo.new(db)              }
    let(:table)   { db[:registrations]                    }

    let(:client) do
      Client.new(addr: addr, busy: true, id: 'cid', type: :FPGA)
    end

    let(:entity) do
      Registration.new(addr: addr, client: client, id: 'an id',
                       project: project, registered_at: Time.new('2015-01-01'))
    end

    let(:row) do
      { client_id: 'cid', host: 'localhost', id: 'an id', port: 1981,
        project_id: 'pid', prot: 'TCP', registered_at: Time.new('2015-01-01') }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
      db[:clients] << client.to_h
      db[:projects] << project.to_h
    end
  end
end
