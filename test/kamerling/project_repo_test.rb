require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'

module Kamerling
  describe ProjectRepo do
    Sequel.extension :migration

    describe '#fetch' do
      it 'returns the Project with the given UUID' do
        db = Sequel.sqlite
        path = "#{__dir__}/../../lib/kamerling/migrations"
        Sequel::Migrator.run db, path
        repo = ProjectRepo.new(db)
        db[:projects].insert name: 'GIMPS', uuid: 'an UUID'
        _(repo.fetch('an UUID')).must_equal Project.new(name: 'GIMPS',
                                                        uuid: 'an UUID')
      end
    end
  end
end
