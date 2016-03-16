# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative 'new_repo_behaviour'

module Kamerling
  describe ClientRepo do
    include NewRepoBehaviour

    Sequel.extension :migration

    let(:db)    { Sequel.sqlite      }
    let(:repo)  { ClientRepo.new(db) }
    let(:table) { db[:clients]       }

    let(:entity) do
      addr = Addr['localhost', 1981, :TCP]
      Client.new(addr: addr, busy: true, type: :FPGA, uuid: 'an UUID')
    end

    let(:row) do
      { busy: true, host: 'localhost', port: 1981, prot: 'TCP', type: 'FPGA',
        uuid: 'an UUID' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
    end

    describe '#<<' do
      it 'updates the row if the Client exists' do
        table.insert(uuid: 'an UUID', busy: false, host: '127.0.0.1',
                     port: 1979, prot: 'UDP')
        repo << entity
        _(table.first).must_equal row
      end
    end

    describe '#for_project' do
      it 'returns all Clients for the given Project UUID' do
        db[:projects] << { name: 'ECC', uuid: 'ecc' }
        db[:projects] << { name: 'GIMPS', uuid: 'gimps' }
        db[:clients] << { busy: false, host: '1.2.3.4', port: 5, prot: 'TCP',
                          uuid: 'ecc_client' }
        db[:clients] << { busy: false, host: '1.2.3.4', port: 5, prot: 'TCP',
                          uuid: 'gimps_client' }
        db[:registrations] << { client_uuid: 'ecc_client', host: '1.2.3.4',
                                port: 5, prot: 'TCP', project_uuid: 'ecc',
                                uuid: 'reg' }
        _(repo.for_project('ecc')).must_equal [Client.new(uuid: 'ecc_client')]
      end
    end
  end
end
