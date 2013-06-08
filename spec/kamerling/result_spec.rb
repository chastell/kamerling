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
end end
