require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/mapper'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/result'
require_relative '../../lib/kamerling/task'

module Kamerling describe Mapper do
  let(:addr)    { Addr['127.0.0.1', 1979, :TCP]                              }
  let(:client)  { Client.new addr: Addr['127.0.0.1', 1979, :TCP], busy: true }
  let(:project) { Project.new name: 'project'                                }
  let(:task)    { Task.new data: 'data', done: true, project: project        }

  describe '.from_h' do
    it 'builds the proper Client from the Hash representation' do
      hash = {
        busy: true,
        host: '127.0.0.1',
        port: 1979,
        prot: 'TCP',
        uuid: client.uuid,
      }
      Mapper.from_h(Client, hash).to_h.must_equal client.to_h
    end

    it 'builds the proper Project from the Hash representation' do
      hash = { name: 'project', uuid: project.uuid }
      Mapper.from_h(Project, hash).to_h.must_equal project.to_h
    end

    it 'builds the proper Task from the Hash representation' do
      repos = { Project => { project.uuid => project } }
      hash  = {
        data:         'data',
        done:         true,
        project_uuid: project.uuid,
        uuid:         task.uuid,
      }
      Mapper.from_h(Task, hash, repos: repos).to_h.must_equal task.to_h
    end
  end

  describe '.to_h' do
    it 'returns the proper Hash representation of a Client' do
      Mapper.to_h(client).must_equal busy: true, host: '127.0.0.1',
                                     port: 1979, prot: 'TCP', uuid: client.uuid
    end

    it 'returns the proper Hash representation of a Dispatch' do
      dispatched_at = Time.new(2014, 7, 6, 5, 4, 3)
      dispatch = Dispatch.new addr: addr, client: client,
                              dispatched_at: dispatched_at, project: project,
                              task: task
      Mapper.to_h(dispatch).must_equal client_uuid: client.uuid,
                                       dispatched_at: dispatched_at,
                                       host: '127.0.0.1', port: 1979,
                                       prot: 'TCP', project_uuid: project.uuid,
                                       task_uuid: task.uuid, uuid: dispatch.uuid
    end

    it 'returns the proper Hash representation of a Registration' do
      registered_at = Time.new(2014, 7, 6, 5, 4, 3)
      reg = Registration.new addr: addr, client: client, project: project,
                             registered_at: registered_at
      Mapper.to_h(reg).must_equal client_uuid: client.uuid, host: '127.0.0.1',
                                  port: 1979, prot: 'TCP',
                                  project_uuid: project.uuid,
                                  registered_at: registered_at, uuid: reg.uuid
    end

    it 'returns the proper Hash representation of a Result' do
      received_at = Time.new(2014, 7, 6, 5, 4, 3)
      result = Result.new addr: addr, client: client, data: 'res',
                          received_at: received_at, task: task
      Mapper.to_h(result).must_equal client_uuid: client.uuid, data: 'res',
                                     host: '127.0.0.1', port: 1979,
                                     prot: 'TCP', received_at: received_at,
                                     task_uuid: task.uuid, uuid: result.uuid
    end

    it 'returns the proper Hash representation of a Tag' do
      Mapper.to_h(task).must_equal data: 'data', done: true,
                                   project_uuid: project.uuid, uuid: task.uuid
    end
  end
end end
