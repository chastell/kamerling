require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative 'repo_behaviour'

module Kamerling
  describe ProjectRepo do
    include RepoBehaviour

    let(:db)     { Sequel.sqlite                           }
    let(:entity) { Project.new(id: 'an id', name: 'GIMPS') }
    let(:repo)   { ProjectRepo.new(db)                     }
    let(:row)    { { id: 'an id', name: 'GIMPS' }          }
    let(:table)  { db[:projects]                           }

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
    end

    describe '#<<' do
      it 'adds a new Project to the repo' do
        assert table.empty?
        repo << entity
        _(table.first).must_equal row
      end
    end
  end
end
