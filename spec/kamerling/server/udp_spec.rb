require_relative '../../spec_helper'

module Kamerling describe Server::UDP do
  let(:addr) { Addr['localhost', 1979, :UDP] }

  describe '#start' do
    it 'listens on an UDP port and passes the received input to the handler' do
      server = Server::UDP.new addr: addr, handler: handler = fake(:handler)
      server.start
      client = UDPSocket.new.tap { |socket| socket.connect(*server.addr) }
      client.send 'message', 0
      c_addr = Addr[client.addr[3], client.addr[1], :UDP]
      2.times { run_all_threads }
      handler.must_have_received :handle, ['message', c_addr]
      server.stop
    end
  end

  describe '#stop' do
    it 'closes the socket (and thus allows rebinding to it)' do
      server = Server::UDP.new(addr: addr).start
      addr   = server.addr
      server.stop
      UDPSocket.new.tap { |socket| socket.bind(*addr) }.close
    end
  end

  describe '#addr' do
    it 'returns the server’s host + port as an UDP addr' do
      server = Server::UDP.new(addr: addr).start
      server.addr.must_equal addr
      server.stop
    end
  end

  describe 'logging' do
    let(:log)    { StringIO.new                               }
    let(:logged) { log.tap(&:rewind).read                     }
    let(:logger) { Logger.new log                             }
    let(:server) { Server::UDP.new addr: addr, logger: logger }

    after { server.stop }

    it 'logs server starts' do
      server.start
      run_all_threads
      logged.must_include "start #{server.addr}"
    end

    it 'logs server connects' do
      server.start
      client = UDPSocket.new.tap { |s| s.connect(*server.addr) }
      client.send '', 0
      addr = Addr[client.addr[3], client.addr[1], :UDP]
      run_all_threads
      logged.must_include "connect #{addr}"
    end

    it 'logs messages received' do
      server.start
      client = UDPSocket.new.tap { |s| s.connect(*server.addr) }
      client.send 'UDP message', 0
      addr = Addr[client.addr[3], client.addr[1], :UDP]
      run_all_threads
      logged.must_include "received #{addr} UDP message"
    end
  end
end end
