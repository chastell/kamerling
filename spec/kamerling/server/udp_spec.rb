require_relative '../../spec_helper'

module Kamerling describe Server::UDP do
  let(:addr) { Addr['localhost', 1979, :UDP] }

  describe '#start' do
    it 'listens on an UDP port and passes received inputs to the handler' do
      server = Server::UDP.new addr: addr, handler: handler = fake(:handler)
      server.start
      foo = UDPSocket.new
      bar = UDPSocket.new
      foo.send 'foo', 0, *server.addr
      bar.send 'bar', 0, *server.addr
      foo_addr = Addr['127.0.0.1', foo.addr[1], :UDP]
      bar_addr = Addr['127.0.0.1', bar.addr[1], :UDP]
      run_all_threads
      server.stop
      handler.must_have_received :handle, ['foo', foo_addr]
      handler.must_have_received :handle, ['bar', bar_addr]
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
      Server::UDP.new(addr: addr).addr.must_equal addr
    end
  end

  describe 'logging' do
    let(:log)    { StringIO.new                               }
    let(:logged) { log.tap(&:rewind).read                     }
    let(:logger) { Logger.new log                             }
    let(:server) { Server::UDP.new addr: addr, logger: logger }

    before { server.start }
    after  { server.stop  }

    it 'logs server starts' do
      logged.must_include "start #{server.addr}"
    end

    it 'logs server connects' do
      client = UDPSocket.new
      client.send 'PING', 0, *server.addr
      addr = Addr['127.0.0.1', client.addr[1], :UDP]
      run_all_threads
      logged.must_include "connect #{addr}"
    end

    it 'logs messages received' do
      client = UDPSocket.new
      client.send 'PING', 0, *server.addr
      addr = Addr['127.0.0.1', client.addr[1], :UDP]
      run_all_threads
      logged.must_include "received #{addr} PING"
    end
  end
end end
