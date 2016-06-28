# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'
require_relative 'repo_behaviour'

module Kamerling
  describe TaskRepo do
    include RepoBehaviour

    let(:db)      { Sequel.sqlite                         }
    let(:project) { Project.new(id: 'pid', name: 'GIMPS') }
    let(:repo)    { TaskRepo.new(db)                      }
    let(:table)   { db[:tasks]                            }

    let(:entity) do
      Task.new(data: 'data', done: true, id: 'an id', project: project)
    end

    let(:row) do
      { data: 'data', done: true, id: 'an id', project_id: 'pid' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
      db[:projects] << project.to_h
    end

    describe '#for_project' do
      it 'returns all Tasks for the given Project' do
        db[:projects] << Project.new(id: 'other', name: 'another').to_h
        table << { data: '', done: true, id: 'tpid',   project_id: 'pid'   }
        table << { data: '', done: true, id: 'tother', project_id: 'other' }
        _(repo.for_project(project)).must_equal [Task.new(id: 'tpid')]
      end
    end

    describe '#next_for_project' do
      it 'returns the first pending Task for the given Project' do
        table << { data: '', done: true,  id: 'done', project_id: 'pid' }
        table << { data: '', done: false, id: 'pend', project_id: 'pid' }
        _(repo.next_for_project(project)).must_equal Task.new(id: 'pend')
      end

      it 'raises NotFound if there’s no free Task' do
        _(-> { repo.next_for_project(project) }).must_raise TaskRepo::NotFound
      end
    end
  end
end
