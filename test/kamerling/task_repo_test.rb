# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
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
  end
end
