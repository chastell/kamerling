require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/project'
require_relative 'repo_behaviour'

module Kamerling
  describe ClientRepo do
    include RepoBehaviour

    let(:addr)    { Addr['localhost', 1981, :TCP] }
    let(:db)      { Sequel.sqlite          }
    let(:project) { Project.new(id: 'ecc') }
    let(:repo)    { ClientRepo.new(db)     }
    let(:table)   { db[:clients]           }

    let(:entity) { Client.new(addr: addr, busy: true, id: 'an id', type: :GPU) }

    let(:row) do
      { busy: true, host: 'localhost', id: 'an id', port: 1981, prot: 'TCP',
        type: 'GPU' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
    end

    describe '#<<' do
      it 'adds a new Client to the repo' do
        assert table.empty?
        repo << entity
        _(table.first).must_equal row
      end

      it 'updates the row if the Client exists' do
        table.insert(busy: false, host: '127.0.0.1', id: 'an id', port: 1979,
                     prot: 'UDP')
        repo << entity
        _(table.first).must_equal row
      end
    end

    describe '#free_for_project' do
      it 'returns free Clients for the given Project' do
        db[:projects] << { id: 'ecc', name: 'ECC' }
        db[:clients] << { busy: false, host: '1.2.3.4', id: 'free', port: 5,
                          prot: 'TCP' }
        db[:clients] << { busy: true, host: '6.7.8.9', id: 'busy', port: 10,
                          prot: 'TCP' }
        db[:registrations] << { client_id: 'free', host: '1.2.3.4', id: 'freg',
                                port: 5, prot: 'TCP', project_id: 'ecc' }
        db[:registrations] << { client_id: 'busy', host: '6.7.8.9', id: 'breg',
                                port: 10, prot: 'TCP', project_id: 'ecc' }
        _(repo.free_for_project(project)).must_equal [Client.new(id: 'free')]
      end
    end

    describe '#for_project' do
      it 'returns all Clients for the given Project' do
        db[:projects] << { id: 'ecc', name: 'ECC' }
        db[:projects] << { id: 'gimps', name: 'GIMPS' }
        db[:clients] << { busy: false, host: '1.2.3.4', id: 'ecc_client',
                          port: 5, prot: 'TCP' }
        db[:clients] << { busy: false, host: '1.2.3.4', id: 'gimps_client',
                          port: 5, prot: 'TCP' }
        db[:registrations] << { client_id: 'ecc_client', host: '1.2.3.4',
                                id: 'reg', port: 5, prot: 'TCP',
                                project_id: 'ecc' }
        _(repo.for_project(project)).must_equal [Client.new(id: 'ecc_client')]
      end
    end

    describe '#mark_busy' do
      it 'marks the given Client as busy' do
        db[:clients] << { busy: false, host: '1.2.3.4', id: 'free', port: 5,
                          prot: 'TCP' }
        refute repo.fetch('free').busy?
        repo.mark_busy(id: 'free')
        assert repo.fetch('free').busy?
      end
    end

    describe '#mark_free' do
      it 'marks the given Client as free' do
        db[:clients] << { busy: true, host: '1.2.3.4', id: 'busy', port: 5,
                          prot: 'TCP' }
        assert repo.fetch('busy').busy?
        repo.mark_free(id: 'busy')
        refute repo.fetch('busy').busy?
      end
    end
  end
end
