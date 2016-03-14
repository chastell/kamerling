# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative 'new_repo_behaviour'

module Kamerling
  describe ProjectRepo do
    include NewRepoBehaviour

    Sequel.extension :migration

    let(:db)     { Sequel.sqlite                               }
    let(:entity) { Project.new(name: 'GIMPS', uuid: 'an UUID') }
    let(:repo)   { ProjectRepo.new(db)                         }
    let(:row)    { { name: 'GIMPS', uuid: 'an UUID' }          }
    let(:table)  { db[:projects]                               }

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
    end

    describe '#fetch_with_clients_and_tasks' do
      it 'returns a Project with all of its Clients and Tasks' do
        db[:clients].insert busy: false, host: 'localhost', port: 1979,
                            prot: 'UDP', uuid: 'cUUID'
        db[:projects].insert name: 'GIMPS', uuid: 'pUUID'
        db[:registrations].insert client_uuid: 'cUUID', host: 'localhost',
                                  port: 1979, project_uuid: 'pUUID',
                                  prot: 'UDP', uuid: 'rUUID'
        db[:tasks].insert done: false, data: 'data', project_uuid: 'pUUID',
                          uuid: 'tUUID'
        project = repo.fetch_with_clients_and_tasks('pUUID')
        _(project).must_equal Project.new(uuid: 'pUUID')
        _(project.clients).must_equal [Client.new(uuid: 'cUUID')]
        _(project.tasks).must_equal [Task.new(uuid: 'tUUID')]
      end
    end
  end
end
