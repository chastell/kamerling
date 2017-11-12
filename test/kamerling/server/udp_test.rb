require 'socket'
require_relative '../../test_helper'
require_relative '../../../lib/kamerling/addr'
require_relative '../../../lib/kamerling/handler'
require_relative '../../../lib/kamerling/message'
require_relative '../../../lib/kamerling/server/udp'
require_relative '../../../lib/kamerling/udp_addr'

module Kamerling
  describe Server::UDP do
    let(:addr) { UDPAddr['localhost', 1979]  }
    let(:udp)  { Server::UDP.new(addr: addr) }

    describe '#==' do
      it 'compares servers by their addresses' do
        assert udp == Server::UDP.new(addr: UDPAddr['localhost', 1979])
        refute udp == Server::UDP.new(addr: UDPAddr['localhost', 1980])
      end
    end

    describe '#addr' do
      it 'returns the server’s host + port as an UDP addr' do
        _(udp.addr).must_equal addr
      end
    end

    describe '#start' do
      it 'listens on an UDP port and passes received inputs to the handler' do
        server = Server::UDP.new(addr: addr, handler: handler = fake(Handler))
        server.start
        foo = UDPSocket.new
        bar = UDPSocket.new
        100.times do
          foo.send 'DATA', 0, *server.addr
          bar.send 'PING', 0, *server.addr
        end
        run_all_threads
        server.stop
        _(handler).must_have_received :handle,
                                      [Message.new('DATA'), addr: any(Addr)]
        _(handler).must_have_received :handle,
                                      [Message.new('PING'), addr: any(Addr)]
      end

      it 'doesn’t blow up on unknown inputs' do
        udp.start
        UDPSocket.new.send 'foo', 0, *udp.addr
        run_all_threads
        udp.stop
      end
    end

    describe '#stop' do
      it 'closes the socket (and thus allows rebinding to it)' do
        udp.start.stop
        UDPSocket.new.tap { |socket| socket.bind(*addr) }.close
      end
    end
  end
end
