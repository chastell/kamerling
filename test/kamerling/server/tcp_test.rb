require 'socket'
require_relative '../../test_helper'
require_relative '../../../lib/kamerling/addr'
require_relative '../../../lib/kamerling/handler'
require_relative '../../../lib/kamerling/message'
require_relative '../../../lib/kamerling/server/tcp'

module Kamerling
  describe Server::TCP do
    let(:addr) { Addr['localhost', 1981, :TCP] }

    describe '#addr' do
      it 'returns the server’s host + port as a TCP addr' do
        _(Server::TCP.new(addr: addr).addr).must_equal addr
      end
    end

    describe '#start' do
      it 'listens on a TCP port and passes received inputs to the handler' do
        server = Server::TCP.new(addr: addr, handler: handler = fake(:handler))
        server.start
        s_addr_foo = TCPSocket.open(*server.addr) do |socket|
          socket << 'DATA'
          Addr[*socket.local_address.ip_unpack, :TCP]
        end
        s_addr_bar = TCPSocket.open(*server.addr) do |socket|
          socket << 'PING'
          Addr[*socket.local_address.ip_unpack, :TCP]
        end
        run_all_threads
        server.stop
        _(handler).must_have_received :handle,
                                      [Message.parse('DATA'), addr: s_addr_foo]
        _(handler).must_have_received :handle,
                                      [Message.parse('PING'), addr: s_addr_bar]
      end

      it 'doesn’t blow up on unknown inputs' do
        server = Server::TCP.new(addr: addr)
        server.start
        TCPSocket.open(*server.addr) { |socket| socket << 'foo' }
        server.stop
      end
    end

    describe '#stop' do
      it 'stops the server' do
        server = Server::TCP.new(addr: addr).start
        server.stop
        _(-> { TCPSocket.open(*addr).close }).must_raise Errno::ECONNREFUSED
      end
    end
  end
end
