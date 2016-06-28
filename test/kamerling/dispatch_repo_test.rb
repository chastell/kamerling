# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/dispatch'
require_relative '../../lib/kamerling/dispatch_repo'
require_relative 'repo_behaviour'

module Kamerling
  describe DispatchRepo do
    include RepoBehaviour

    Sequel.extension :migration

    let(:addr)    { Addr['localhost', 1981, :TCP]                       }
    let(:db)      { Sequel.sqlite                                       }
    let(:project) { Project.new(id: 'pid', name: 'GIMPS')               }
    let(:repo)    { DispatchRepo.new(db)                                }
    let(:table)   { db[:dispatches]                                     }
    let(:task)    { Task.new(data: 'data', id: 'tid', project: project) }

    let(:client) do
      Client.new(addr: addr, busy: true, id: 'cid', type: :FPGA)
    end

    let(:entity) do
      Dispatch.new(addr: addr, client: client,
                   dispatched_at: Time.new('2015-01-01'), id: 'an id',
                   project: project, task: task)
    end

    let(:row) do
      { client_id: 'cid', dispatched_at: Time.new('2015-01-01'),
        host: 'localhost', id: 'an id', port: 1981, project_id: 'pid',
        prot: 'TCP', task_id: 'tid' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
      db[:clients] << client.to_h
      db[:projects] << project.to_h
      db[:tasks] << task.to_h
    end
  end
end
