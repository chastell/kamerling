# frozen_string_literal: true

require 'socket'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/net_dispatcher'

module Kamerling
  describe NetDispatcher do
    describe '#dispatch' do
      it 'dispatches messages to TCP clients' do
        server = TCPServer.open(0)
        thread = Thread.new { server.accept.read }
        addr   = Addr[server.addr[3], server.addr[1], :TCP]
        NetDispatcher.dispatch Message.parse('PING'), addr: addr
        _(thread.value).must_equal 'PING'
      end

      it 'dispatches messages to UDP clients' do
        server = UDPSocket.new.tap { |s| s.bind '127.0.0.1', 0 }
        thread = Thread.new { server.recvfrom(2**16).first }
        addr   = Addr[server.addr[3], server.addr[1], :UDP]
        NetDispatcher.dispatch Message.parse('PING'), addr: addr
        _(thread.value).must_equal 'PING'
      end
    end
  end
end
