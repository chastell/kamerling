# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/registration_repo'
require_relative '../../lib/kamerling/repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/result'
require_relative '../../lib/kamerling/result_repo'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'
require_relative '../../lib/kamerling/uuid'

module Kamerling
  describe Repos do
    describe '.<<' do
      it 'shuffles the object into the right repo' do
        Repos.repos = { Object => repo = fake(Repo) }
        Repos.<< object = Object.new
        _(repo).must_have_received :<<, [object]
      end

      it 'can be chained' do
        str_repo = fake(Repo)
        sym_repo = fake(Repo)
        Repos.repos = { String => str_repo, Symbol => sym_repo }
        Repos << 'str' << :sym
        _(str_repo).must_have_received :<<, ['str']
        _(sym_repo).must_have_received :<<, [:sym]
      end
    end

    describe '.client_repo' do
      it 'returns a ClientRepo' do
        _(Repos.client_repo).must_be_kind_of ClientRepo
      end
    end

    describe '.db=' do
      it 'auto-migrates the passed db' do
        db = Sequel.sqlite
        _(db.tables).wont_include :schema_info
        Repos.db = db
        _(db.tables).must_include :schema_info
      end
    end

    describe '.project_repo' do
      it 'returns a ProjectRepo' do
        _(Repos.project_repo).must_be_kind_of ProjectRepo
      end
    end

    describe '.registration_repo' do
      it 'returns a RegistrationRepo' do
        _(Repos.registration_repo).must_be_kind_of RegistrationRepo
      end
    end

    describe '.result_repo' do
      it 'returns a ResultRepo' do
        _(Repos.result_repo).must_be_kind_of ResultRepo
      end
    end

    describe '.task_repo' do
      it 'returns a TaskRepo' do
        _(Repos.task_repo).must_be_kind_of TaskRepo
      end
    end
  end
end
