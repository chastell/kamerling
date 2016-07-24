# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'

module Kamerling
  describe Repos do
    Sequel.extension :migration

    let(:addr)    { Addr['localhost', 1981, :TCP]                              }
    let(:client)  { Client.new(addr: addr, busy: true, id: 'cid', type: :FPGA) }
    let(:db)      { Sequel.sqlite                                              }
    let(:project) { Project.new(id: 'pid', name: 'GIMPS')                      }
    let(:repos)   { Repos.new(db: db)                                          }
    let(:task)    { Task.new(data: 'data', id: 'tid', project: project)        }

    before do
      Sequel::Migrator.run db, "#{__dir__}/../../lib/kamerling/migrations"
      db[:clients]  << client.to_h
      db[:projects] << project.to_h
      db[:tasks]    << task.to_h
    end

    describe '#client_repo' do
      it 'returns a ClientRepo for the db connection' do
        _(Repos.new.client_repo).must_be_kind_of ClientRepo
      end
    end

    describe '#project_repo' do
      it 'returns a ProjectRepo for the db connection' do
        _(Repos.new.project_repo).must_be_kind_of ProjectRepo
      end
    end

    describe '#record_dispatch' do
      it 'records a dispatch' do
        repos.record_dispatch client: client, project: project, task: task
        row = { client_id: 'cid', dispatched_at: any(Time), host: 'localhost',
                id: any(String), port: 1981, project_id: 'pid', prot: 'TCP',
                task_id: 'tid' }
        _(db[:dispatches].first).must_equal row
      end
    end

    describe '#record_registration' do
      it 'records a registration' do
        repos.record_registration addr: addr, client: client, project: project
        row = { client_id: 'cid', registered_at: any(Time), host: 'localhost',
                id: any(String), port: 1981, project_id: 'pid', prot: 'TCP' }
        _(db[:registrations].first).must_equal row
      end
    end

    describe '#record_result' do
      it 'records a result' do
        repos.record_result addr: addr, client: client, data: 'data', task: task
        row = { client_id: 'cid', data: 'data', host: 'localhost',
                id: any(String), port: 1981, prot: 'TCP',
                received_at: any(Time), task_id: 'tid' }
        _(db[:results].first).must_equal row
      end
    end

    describe '#task_repo' do
      it 'returns a TaskRepo for the db connection' do
        _(Repos.new.task_repo).must_be_kind_of TaskRepo
      end
    end
  end
end
