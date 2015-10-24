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
  end
end
