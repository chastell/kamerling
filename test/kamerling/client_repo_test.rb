require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'

module Kamerling
  describe ClientRepo do
    Sequel.extension :migration

    let(:client) do
      addr = Addr['localhost', 1981, :TCP]
      Client.new(addr: addr, busy: true, type: :FPGA, uuid: 'an UUID')
    end
    let(:db)   { Sequel.sqlite      }
    let(:repo) { ClientRepo.new(db) }
    let(:row) do
      { busy: true, host: 'localhost', port: 1981, prot: 'TCP', type: 'FPGA',
        uuid: 'an UUID' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
    end

    describe '#<<' do
      it 'adds a new Client to the repo' do
        assert db[:clients].empty?
        repo << client
        _(db[:clients].first).must_equal row
      end

      it 'updates the row if the Client exists' do
        db[:clients].insert(uuid: 'an UUID', busy: false, host: '127.0.0.1',
                            port: 1979, prot: 'UDP')
        repo << client
        _(db[:clients].first).must_equal row
      end
    end

    describe '#all' do
      it 'returns all the rows as Clients' do
        db[:clients].insert(uuid: 'UDP client', busy: false, host: '127.0.0.1',
                            port: 1979, prot: 'UDP')
        db[:clients].insert(uuid: 'TCP client', busy: true, host: 'localhost',
                            port: 1981, prot: 'TCP')
        _(repo.all).must_equal [
          Client.new(uuid: 'UDP client'),
          Client.new(uuid: 'TCP client'),
        ]
      end
    end

    describe '#fetch' do
      it 'returns the Client with the given UUID' do
        db[:clients].insert(uuid: 'an UUID', busy: false, host: '127.0.0.1',
                            port: 1979, prot: 'UDP')
        _(repo.fetch('an UUID')).must_equal client
      end

      it 'evaluates the block if the given UUID is missing' do
        evaluated = false
        repo.fetch('an UUID') { evaluated = true }
        assert evaluated
      end
    end
  end
end
