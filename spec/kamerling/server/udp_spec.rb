require_relative '../../spec_helper'

module Kamerling describe Server::UDP do
  describe '.new' do
    it 'defaults to localhost' do
      server = Server::UDP.new(port: 1979).start
      server.addr.host.must_equal '127.0.0.1'
      server.stop
    end
  end

  describe '#start' do
    it 'listens on an UDP port and passes the received input to the handler' do
      server = Server::UDP.new handler: handler = fake(:handler), port: 1979
      server.start
      client = UDPSocket.new.tap { |s| s.connect(*server.addr) }
      client.send 'message', 0
      c_addr = Addr[client.addr[3], client.addr[1], :UDP]
      2.times { run_all_threads }
      handler.must_have_received :handle, ['message', c_addr]
      server.stop
    end
  end

  describe '#stop' do
    it 'closes the socket (and thus allows rebinding to it)' do
      server = Server::UDP.new(port: 1979).start
      addr   = server.addr
      server.stop
      UDPSocket.new.tap { |socket| socket.bind(*addr) }.close
    end
  end

  describe '#addr' do
    it 'returns the server’s host + port as an UDP addr' do
      server = Server::UDP.new(host: '0.0.0.0', port: 1979).start
      server.addr.must_equal Addr['0.0.0.0', 1979, :UDP]
      server.stop
    end
  end

  describe 'logging' do
    let(:log)    { StringIO.new                               }
    let(:logged) { log.tap(&:rewind).read                     }
    let(:logger) { Logger.new log                             }
    let(:server) { Server::UDP.new logger: logger, port: 1979 }

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
