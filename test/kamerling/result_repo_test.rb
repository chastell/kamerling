# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/result_repo'
require_relative '../../lib/kamerling/task'
require_relative 'repo_behaviour'

module Kamerling
  describe ResultRepo do
    include RepoBehaviour

    let(:addr)    { Addr['localhost', 1981, :TCP]                       }
    let(:client)  { Client.new(addr: addr, id: 'cid')                   }
    let(:db)      { Sequel.sqlite                                       }
    let(:project) { Project.new(id: 'pid', name: 'GIMPS')               }
    let(:repo)    { ResultRepo.new(db)                                  }
    let(:table)   { db[:results]                                        }
    let(:task)    { Task.new(data: 'data', id: 'tid', project: project) }

    let(:entity) do
      Result.new(addr: addr, client: client, data: 'data', id: 'an id',
                 received_at: Time.new('2015-01-01'), task: task)
    end

    let(:row) do
      { client_id: 'cid', data: 'data', host: 'localhost', id: 'an id',
        port: 1981, prot: 'TCP', received_at: Time.new('2015-01-01'),
        task_id: 'tid' }
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
