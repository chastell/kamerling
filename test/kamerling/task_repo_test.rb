# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'
require_relative 'new_repo_behaviour'

module Kamerling
  describe TaskRepo do
    include NewRepoBehaviour

    let(:db)      { Sequel.sqlite                             }
    let(:project) { Project.new(name: 'GIMPS', uuid: 'pUUID') }
    let(:repo)    { TaskRepo.new(db)                          }
    let(:table)   { db[:tasks]                                }

    let(:entity) do
      Task.new(data: 'data', done: true, project: project, uuid: 'an UUID')
    end

    let(:row) do
      { data: 'data', done: true, project_uuid: 'pUUID', uuid: 'an UUID' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
      db[:projects] << project.new_to_h
    end

    describe '#for_project' do
      it 'returns all Tasks for the given Project UUID' do
        db[:projects] << Project.new(name: 'another', uuid: 'other').new_to_h
        table << { data: '', done: true, project_uuid: 'pUUID', uuid: 'tpUUID' }
        table << { data: '', done: true, project_uuid: 'other', uuid: 'tother' }
        _(repo.for_project('pUUID')).must_equal [Task.new(uuid: 'tpUUID')]
      end
    end

    describe '#next_for_project' do
      it 'returns the first pending Task for the given Project UUID' do
        table << { data: '', done: true,  project_uuid: 'pUUID', uuid: 'done' }
        table << { data: '', done: false, project_uuid: 'pUUID', uuid: 'pend' }
        _(repo.next_for_project('pUUID')).must_equal Task.new(uuid: 'pend')
      end

      it 'raises NotFound if there’s no free Task' do
        _(-> { repo.next_for_project('pUUID') }).must_raise TaskRepo::NotFound
      end
    end
  end
end
