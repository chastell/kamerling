require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'

module Kamerling
  describe ProjectRepo do
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

    describe '#fetch' do
      it 'returns the Project with the given UUID' do
        table.insert row
        _(repo.fetch('an UUID')).must_equal entity
      end
    end
  end
end
