require 'socket'
require_relative '../../test_helper'
require_relative '../../../lib/kamerling/addr'
require_relative '../../../lib/kamerling/handler'
require_relative '../../../lib/kamerling/message'
require_relative '../../../lib/kamerling/server/udp'

module Kamerling
  describe Server::UDP do
    let(:addr) { Addr['localhost', 1979, :UDP] }

    describe '#start' do
      it 'listens on an UDP port and passes received inputs to the handler' do
        server = Server::UDP.new(addr: addr, handler: handler = fake(:handler))
        server.start
        foo = UDPSocket.new
        bar = UDPSocket.new
        3.times do
          foo.send 'DATA', 0, *server.addr
          bar.send 'PING', 0, *server.addr
        end
        run_all_threads
        server.stop
        _(handler).must_have_received :handle,
                                      [Message.parse('DATA'), addr: any(Addr)]
        _(handler).must_have_received :handle,
                                      [Message.parse('PING'), addr: any(Addr)]
      end

      it 'doesn’t blow up on unknown inputs' do
        server = Server::UDP.new(addr: addr)
        server.start
        UDPSocket.new.send 'foo', 0, *server.addr
        run_all_threads
        server.stop
      end
    end

    describe '#stop' do
      it 'closes the socket (and thus allows rebinding to it)' do
        Server::UDP.new(addr: addr).start.stop
        UDPSocket.new.tap { |socket| socket.bind(*addr) }.close
      end
    end

    describe '#addr' do
      it 'returns the server’s host + port as an UDP addr' do
        _(Server::UDP.new(addr: addr).addr).must_equal addr
      end
    end
  end
end
