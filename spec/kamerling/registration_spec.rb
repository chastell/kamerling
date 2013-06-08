require_relative '../spec_helper'

module Kamerling describe Registration do
  fakes :addr, :client, :project

  describe '.new' do
    it 'gives the registration a random UUID' do
      r1 = Registration[addr: addr, client: client, project: project]
      r2 = Registration[addr: addr, client: client, project: project]
      r1.uuid.wont_equal r2.uuid
    end
  end
end end
