require_relative '../../spec_helper'
require_relative '../../../lib/kamerling/server/tcp'

module Kamerling describe Server::TCP do
  let(:addr) { Addr['localhost', 1981, :TCP] }

  describe '#addr' do
    it 'returns the server’s host + port as a TCP addr' do
      Server::TCP.new(addr: addr).addr.must_equal addr
    end
  end

  describe '#start' do
    it 'listens on a TCP port and passes received inputs to the handler' do
      server = Server::TCP.new addr: addr, handler: handler = fake(:handler)
      server.start
      s_addr_foo = TCPSocket.open(*server.addr) do |socket|
        socket << 'foo'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      s_addr_bar = TCPSocket.open(*server.addr) do |socket|
        socket << 'bar'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      server.stop
      handler.must_have_received :handle, ['foo', s_addr_foo]
      handler.must_have_received :handle, ['bar', s_addr_bar]
    end

    it 'doesn’t blow up on unknown inputs' do
      server = Server::TCP.new addr: addr, handler: handler = fake(:handler)
      server.start
      stub(handler).handle('foo', any(Addr)) { fail Handler::UnknownInput }
      TCPSocket.open(*server.addr) { |socket| socket << 'foo' }
      server.stop
    end
  end

  describe '#stop' do
    it 'stops the server' do
      server = Server::TCP.new(addr: addr).start
      server.stop
      -> { TCPSocket.open(*addr).close }.must_raise Errno::ECONNREFUSED
    end
  end
end end
