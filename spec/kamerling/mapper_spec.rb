require_relative '../spec_helper'

module Kamerling describe Mapper do
  describe '.to_h' do
    it 'returns Hash representation of a Client' do
      client = Client.new addr: Addr['127.0.0.1', 1979, :TCP], busy: true
      Mapper.to_h(client).must_equal busy: true, host: '127.0.0.1',
                                     port: 1979, prot: 'TCP', uuid: client.uuid
    end
  end
end end
