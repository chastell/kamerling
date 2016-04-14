# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative 'repo_behaviour'

module Kamerling
  describe ProjectRepo do
    include RepoBehaviour

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
  end
end
