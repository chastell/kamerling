# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/dispatch_repo'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/registration_repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/result_repo'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'

module Kamerling
  describe Repos do
    Sequel.extension :migration

    describe '#client_repo' do
      it 'returns a ClientRepo for the db connection' do
        _(Repos.new.client_repo).must_be_kind_of ClientRepo
      end
    end

    describe '#dispatch_repo' do
      it 'returns a DispatchRepo for the db connection' do
        _(Repos.new.dispatch_repo).must_be_kind_of DispatchRepo
      end
    end

    describe '#project_repo' do
      it 'returns a ProjectRepo for the db connection' do
        _(Repos.new.project_repo).must_be_kind_of ProjectRepo
      end
    end

    describe '#record_dispatch' do
      it 'records a dispatch' do
        db   = Sequel.sqlite
        path = "#{__dir__}/../../lib/kamerling/migrations"
        Sequel::Migrator.run db, path
        addr    = Addr['localhost', 1981, :TCP]
        client  = Client.new(addr: addr, busy: true, id: 'cid', type: :FPGA)
        project = Project.new(id: 'pid', name: 'GIMPS')
        task    = Task.new(data: 'data', id: 'tid', project: project)
        db[:clients]  << client.to_h
        db[:projects] << project.to_h
        db[:tasks]    << task.to_h
        repos = Repos.new(db: db)
        repos.record_dispatch client: client, project: project, task: task
        row = { client_id: 'cid', dispatched_at: any(Time), host: 'localhost',
                id: any(String), port: 1981, project_id: 'pid', prot: 'TCP',
                task_id: 'tid' }
        _(db[:dispatches].first).must_equal row
      end
    end

    describe '#registration_repo' do
      it 'returns a RegistrationRepo for the db connection' do
        _(Repos.new.registration_repo).must_be_kind_of RegistrationRepo
      end
    end

    describe '#result_repo' do
      it 'returns a ResultRepo for the db connection' do
        _(Repos.new.result_repo).must_be_kind_of ResultRepo
      end
    end

    describe '#task_repo' do
      it 'returns a TaskRepo for the db connection' do
        _(Repos.new.task_repo).must_be_kind_of TaskRepo
      end
    end
  end
end
