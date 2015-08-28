require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'

module Kamerling
  describe ClientRepo do
    Sequel.extension :migration

    describe '#<<' do
      it 'adds a new Client to the repo' do
        db = Sequel.sqlite
        path = "#{__dir__}/../../lib/kamerling/migrations"
        warn_off { Sequel::Migrator.run db, path }
        assert warn_off { db[:clients].empty? }
        repo = ClientRepo.new(db)
        addr = Addr['localhost', 1981, :TCP]
        repo << Client.new(addr: addr, busy: true, type: :FPGA)
        _(warn_off { db[:clients].first }).must_equal(uuid: any(String),
                                                      busy: true,
                                                      host: 'localhost',
                                                      port: 1981,
                                                      prot: 'TCP',
                                                      type: 'FPGA')
      end
    end
  end
end
