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
      warn_off { Sequel::Migrator.run db, path }
    end

    describe '#<<' do
      it 'adds a new Client to the repo' do
        assert warn_off { db[:clients].empty? }
        repo << client
        _(warn_off { db[:clients].first }).must_equal row
      end

      it 'updates the row if the Client exists' do
        warn_off do
          db[:clients].insert(uuid: 'an UUID', busy: false, host: '127.0.0.1',
                              port: 1979, prot: 'UDP')
        end
        repo << client
        _(warn_off { db[:clients].first }).must_equal row
      end
    end

    describe '#all' do
      it 'returns all the rows as Clients' do
        warn_off do
          db[:clients].insert(uuid: 'UDP client', busy: false,
                              host: '127.0.0.1', port: 1979, prot: 'UDP')
          db[:clients].insert(uuid: 'TCP client', busy: true,
                              host: 'localhost', port: 1981, prot: 'TCP')
        end
        _(repo.all).must_equal [
          Client.new(uuid: 'UDP client'),
          Client.new(uuid: 'TCP client'),
        ]
      end
    end
  end
end
