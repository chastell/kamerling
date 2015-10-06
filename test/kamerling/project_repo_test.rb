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

    let(:entities) do
      [Project.new(uuid: 'Golomb UUID'), Project.new(uuid: 'GIMPS UUID')]
    end

    let(:rows) do
      [
        { name: 'Golomb', uuid: 'Golomb UUID' },
        { name: 'GIMPS',  uuid: 'GIMPS UUID'  },
      ]
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
    end

    describe '#all' do
      it 'returns all Projects' do
        rows.each { |row| table << row }
        _(repo.all).must_equal entities
      end
    end
  end
end
