# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/dispatch'
require_relative '../../lib/kamerling/dispatch_repo'
require_relative 'new_repo_behaviour'

module Kamerling
  describe DispatchRepo do
    include NewRepoBehaviour

    Sequel.extension :migration

    let(:addr)    { Addr['localhost', 1981, :TCP]                           }
    let(:db)      { Sequel.sqlite                                           }
    let(:project) { Project.new(name: 'GIMPS', uuid: 'pUUID')               }
    let(:repo)    { DispatchRepo.new(db)                                    }
    let(:table)   { db[:dispatches]                                         }
    let(:task)    { Task.new(data: 'data', project: project, uuid: 'tUUID') }

    let(:client) do
      Client.new(addr: addr, busy: true, type: :FPGA, uuid: 'cUUID')
    end

    let(:entity) do
      Dispatch.new(addr: addr, client: client,
                   dispatched_at: Time.new('2015-01-01'), project: project,
                   task: task, uuid: 'an UUID')
    end

    let(:row) do
      { client_uuid: 'cUUID', dispatched_at: Time.new('2015-01-01'),
        host: 'localhost', port: 1981, project_uuid: 'pUUID', prot: 'TCP',
        task_uuid: 'tUUID', uuid: 'an UUID' }
    end

    before do
      path = "#{__dir__}/../../lib/kamerling/migrations"
      Sequel::Migrator.run db, path
      db[:clients] << client.new_to_h
      db[:projects] << project.new_to_h
      db[:tasks] << task.new_to_h
    end
  end
end
