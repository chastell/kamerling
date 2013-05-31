require_relative '../spec_helper'

module Kamerling describe Result do
  fakes :addr, :client, :task

  describe '.from_h' do
    it 'backtranslates client_uuid, host, port and task_uuid' do
      addr  = Addr['127.0.0.1', 1981]
      repos = { Client => { client.uuid => client },
        Task => { task.uuid => task } }
      hash  = { client_uuid: client.uuid, data: 'result data', host: addr.host,
        port: addr.port, task_uuid: task.uuid }
      Result.from_h(hash, repos).must_equal Result[addr: addr, client: client,
        data: 'result data', task: task, uuid: anything]
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
