require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative 'new_repo_behaviour'

module Kamerling
  describe ClientRepo do
    include NewRepoBehaviour

    Sequel.extension :migration

    let(:db) { Sequel.sqlite }
    let(:entity) do
      addr = Addr['localhost', 1981, :TCP]
      Client.new(addr: addr, busy: true, type: :FPGA, uuid: 'an UUID')
    end
    let(:repo) { ClientRepo.new(db) }
    let(:row) do
      { busy: true, host: 'localhost', port: 1981, prot: 'TCP', type: 'FPGA',
        uuid: 'an UUID' }
    end
    let(:table) { db[:clients] }

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

    describe '#all' do
      it 'returns all the rows as Clients' do
        table.insert(uuid: 'UDP client', busy: false, host: '127.0.0.1',
                     port: 1979, prot: 'UDP')
        table.insert(uuid: 'TCP client', busy: true, host: 'localhost',
                     port: 1981, prot: 'TCP')
        _(repo.all).must_equal [
          Client.new(uuid: 'UDP client'),
          Client.new(uuid: 'TCP client'),
        ]
      end
    end

    describe '#fetch' do
      it 'evaluates the block if the given UUID is missing' do
        evaluated = false
        repo.fetch('an UUID') { evaluated = true }
        assert evaluated
      end
    end
  end
end
