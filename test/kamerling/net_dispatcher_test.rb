require 'socket'
require_relative '../test_helper'
require_relative '../../lib/kamerling/net_dispatcher'
require_relative '../../lib/kamerling/tcp_addr'
require_relative '../../lib/kamerling/udp_addr'

module Kamerling
  describe NetDispatcher do
    describe '#dispatch' do
      it 'dispatches messages to TCP clients' do
        server = TCPServer.open(0)
        thread = Thread.new { server.accept.read }
        addr   = TCPAddr[server.addr[3], server.addr[1]]
        NetDispatcher.dispatch 'PING', addr: addr
        _(thread.value).must_equal 'PING'
      end

      it 'dispatches messages to UDP clients' do
        server = UDPSocket.new.tap { |s| s.bind '127.0.0.1', 0 }
        thread = Thread.new { server.recvfrom(2**16).first }
        addr   = UDPAddr[server.addr[3], server.addr[1]]
        NetDispatcher.dispatch 'PING', addr: addr
        _(thread.value).must_equal 'PING'
      end
    end
  end
end
