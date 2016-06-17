# frozen_string_literal: true

require 'socket'
require_relative '../../test_helper'
require_relative '../../../lib/kamerling/addr'
require_relative '../../../lib/kamerling/handler'
require_relative '../../../lib/kamerling/message'
require_relative '../../../lib/kamerling/server/tcp'

module Kamerling
  describe Server::TCP do
    let(:addr) { Addr['localhost', 1981, :TCP] }
    let(:tcp)  { Server::TCP.new(addr: addr)   }

    describe '#==' do
      it 'compares servers by their addresses' do
        assert tcp == Server::TCP.new(addr: Addr['localhost', 1981, :TCP])
        refute tcp == Server::TCP.new(addr: Addr['localhost', 1982, :TCP])
      end
    end

    describe '#addr' do
      it 'returns the server’s host + port as a TCP addr' do
        _(tcp.addr).must_equal addr
      end
    end

    describe '#start' do
      it 'listens on a TCP port and passes received inputs to the handler' do
        server = Server::TCP.new(addr: addr, handler: handler = fake(Handler))
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
                                      [Message.new('DATA'), addr: s_addr_foo]
        _(handler).must_have_received :handle,
                                      [Message.new('PING'), addr: s_addr_bar]
      end

      it 'doesn’t blow up on unknown inputs' do
        tcp.start
        TCPSocket.open(*tcp.addr) { |socket| socket << 'foo' }
        tcp.stop
      end
    end

    describe '#stop' do
      it 'stops the server' do
        tcp.start.stop
        _(-> { TCPSocket.open(*addr).close }).must_raise Errno::ECONNREFUSED
      end
    end
  end
end
