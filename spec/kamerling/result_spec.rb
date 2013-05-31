require_relative '../spec_helper'

module Kamerling describe Result do
  fakes :addr, :client, :task

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
