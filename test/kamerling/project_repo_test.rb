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

    describe '#all' do
      it 'returns all Projects' do
        table.insert name: 'ECC',   uuid: 'ECC id'
        table.insert name: 'GIMPS', uuid: 'GIMPS id'
        projects = [Project.new(uuid: 'ECC id'), Project.new(uuid: 'GIMPS id')]
        _(repo.all).must_equal projects
      end
    end
  end
end
