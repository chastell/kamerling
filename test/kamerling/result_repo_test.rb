# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/result_repo'

module Kamerling
  describe ResultRepo do
    include NewRepoBehaviour

    let(:addr)    { Addr['localhost', 1981, :TCP]                           }
    let(:client)  { Client.new(addr: addr, uuid: 'cUUID')                   }
    let(:db)      { Sequel.sqlite                                           }
    let(:project) { Project.new(name: 'GIMPS', uuid: 'pUUID')               }
    let(:repo)    { ResultRepo.new(db)                                      }
    let(:table)   { db[:results]                                            }
    let(:task)    { Task.new(data: 'data', project: project, uuid: 'tUUID') }

    let(:entity) do
      Result.new(addr: addr, client: client, data: 'data', task: task,
                 received_at: Time.new('2015-01-01'), uuid: 'an UUID')
    end

    let(:row) do
      { client_uuid: 'cUUID', data: 'data', host: 'localhost', port: 1981,
        prot: 'TCP', received_at: Time.new('2015-01-01'), task_uuid: 'tUUID',
        uuid: 'an UUID' }
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
