require_relative '../spec_helper'

module Kamerling describe Server do
  describe '.new' do
    it 'starts a server on the given host and port' do
      Server.new(host: '0.0.0.0', port: 1981).start
      TCPSocket.open '0.0.0.0', 1981
    end

    it 'defaults to localhost' do
      Server.new.host.must_equal '127.0.0.1'
    end

    it 'defaults to a random, unused port' do
      s1, s2 = Server.new.start, Server.new.start
      (1024..65535).must_include s1.port
      (1024..65535).must_include s2.port
      s1.port.wont_equal s2.port
      TCPSocket.open s1.host, s1.port
      TCPSocket.open s2.host, s2.port
    end
  end

  describe '#addr' do
    it 'returns the server’s host + port as an addr' do
      server = Server.new
      server.addr.must_equal Addr[server.host, server.port]
    end
  end

  describe '#serve' do
    it 'passes the received input to the handler' do
      server = Server.new(handler: handler = fake(:handler)).start
      s_addr = nil
      TCPSocket.open server.host, server.port do |socket|
        socket << 'message'
        s_addr = Addr[*socket.local_address.ip_unpack]
      end
      sleep 0.02
      handler.must_have_received :handle, ['message', s_addr]
    end
  end
end end
