require_relative '../spec_helper'

module Kamerling describe Result do
  before { Repos.db = Sequel.sqlite }

  fakes :addr, :client, :task

  describe '.from_h' do
    it 'backtranslates client_uuid, host, port and task_uuid' do
      addr = Addr['127.0.0.1', 1981]
      Repos << client  = Client[addr: addr, uuid: UUID.new]
      Repos << project = Project[name: 'project name', uuid: UUID.new]
      Repos << task    = Task[input: 'input', project: project, uuid: UUID.new]
      res = Result.from_h client_uuid: client.uuid, data: 'data',
        host: '127.0.0.1', port: 1981, task_uuid: task.uuid
      res.must_equal Result[addr: addr, client: client, data: 'data',
        task: task, uuid: anything]
    end
  end

  describe '.new' do
    it 'gives the result a random UUID' do
      r1 = Result[addr: addr, client: client, data: 'some data', task: task]
      r2 = Result[addr: addr, client: client, data: 'some data', task: task]
      r1.uuid.wont_equal r2.uuid
    end
  end

  describe '#to_h' do
    it 'serialises addr, client and task' do
      hash = Result[addr: addr, client: client, data: 'data', task: task].to_h
      hash.must_equal({ client_uuid: client.uuid, data: 'data', host: addr.host,
        port: addr.port, task_uuid: task.uuid, uuid: anything })
    end
  end
end end
