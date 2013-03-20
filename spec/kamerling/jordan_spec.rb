require_relative '../spec_helper'

module Kamerling describe Jordan do
  describe '.new' do
    it 'starts a server on the given host and port' do
      Jordan.new host: '0.0.0.0', port: 1981
      TCPSocket.new('0.0.0.0', 1981).close
    end

    it 'defaults to localhost' do
      Jordan.new.host.must_equal '127.0.0.1'
    end

    it 'defaults to a random, unused port' do
      j1, j2 = Jordan.new, Jordan.new
      assert (1024..65535).include? j1.port
      assert (1024..65535).include? j2.port
      refute j1.port == j2.port
      TCPSocket.new(j1.host, j1.port).close
      TCPSocket.new(j2.host, j2.port).close
    end
  end
end end
