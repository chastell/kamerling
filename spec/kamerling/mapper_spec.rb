require_relative '../spec_helper'

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
      Mapper.from_h(Client, hash).must_equal client
    end
  end

  describe '.to_h' do
    it 'returns the proper Hash representation of a Client' do
      Mapper.to_h(client).must_equal busy: true, host: '127.0.0.1',
                                     port: 1979, prot: 'TCP', uuid: client.uuid
    end

    it 'returns the proper Hash representation of a Registration' do
      reg = Registration.new addr: addr, client: client, project: project
      Mapper.to_h(reg).must_equal client_uuid: client.uuid, host: '127.0.0.1',
                                  port: 1979, prot: 'TCP',
                                  project_uuid: project.uuid, uuid: reg.uuid
    end

    it 'returns the proper Hash representation of a Result' do
      result = Result.new addr: addr, client: client, data: 'res', task: task
      Mapper.to_h(result).must_equal client_uuid: client.uuid, data: 'res',
                                     host: '127.0.0.1', port: 1979,
                                     prot: 'TCP', task_uuid: task.uuid,
                                     uuid: result.uuid
    end

    it 'returns the proper Hash representation of a Tag' do
      Mapper.to_h(task).must_equal data: 'data', done: true,
                                   project_uuid: project.uuid, uuid: task.uuid
    end
  end
end end
