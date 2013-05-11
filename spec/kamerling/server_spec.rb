require_relative '../spec_helper'

module Kamerling describe Server do
  describe '.new' do
    it 'starts a server on the given host and port' do
      Server.new host: '0.0.0.0', port: 1981
      TCPSocket.open '0.0.0.0', 1981
    end

    it 'defaults to localhost' do
      Server.new.host.must_equal '127.0.0.1'
    end

    it 'defaults to a random, unused port' do
      j1, j2 = Server.new, Server.new
      assert (1024..65535).include? j1.port
      assert (1024..65535).include? j2.port
      refute j1.port == j2.port
      TCPSocket.open j1.host, j1.port
      TCPSocket.open j2.host, j2.port
    end
  end

  describe '#serve' do
    it 'passes the received input to the handler' do
      handler = MiniTest::Mock.new.expect :handle, nil, ['message', Addrinfo]
      server  = Server.new handler: handler
      TCPSocket.open(server.host, server.port) { |socket| socket << 'message' }
      sleep 0.001
      handler.verify
    end
  end
end end
