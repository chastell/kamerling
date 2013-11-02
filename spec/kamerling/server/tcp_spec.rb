require_relative '../../spec_helper'

module Kamerling describe Server::TCP do
  describe '.new' do
    it 'sets up a TCP server on the given host and port' do
      Server::TCP.new(host: '0.0.0.0', port: 1981).start
      TCPSocket.open '0.0.0.0', 1981
    end

    it 'defaults to localhost' do
      Server::TCP.new.addr.host.must_equal '127.0.0.1'
    end

    it 'defaults to random, unused ports' do
      s1, s2 = Server::TCP.new.start, Server::TCP.new.start
      (1024..65_535).must_include s1.addr.port
      (1024..65_535).must_include s2.addr.port
      s1.addr.port.wont_equal s2.addr.port
    end
  end

  describe '#start' do
    it 'listens on a TCP port and passes the received input to the handler' do
      server = Server::TCP.new(handler: handler = fake(:handler)).start
      s_addr = TCPSocket.open(*server.addr) do |socket|
        socket << 'message'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      3.times { run_all_threads }
      handler.must_have_received :handle, ['message', s_addr]
    end
  end

  describe '#addr' do
    it 'returns the server’s host + port as a TCP addr' do
      server = Server::TCP.new
      server.addr.must_equal Addr['127.0.0.1', server.addr.port, :TCP]
    end
  end

  describe 'logging' do
    let(:log)    { StringIO.new                   }
    let(:logged) { log.tap(&:rewind).read         }
    let(:logger) { Logger.new log                 }
    let(:server) { Server::TCP.new logger: logger }

    it 'logs server starts' do
      server.start
      run_all_threads
      logged.must_include "start #{server.addr}"
    end

    it 'logs server connects' do
      server.start
      tcp_addr = TCPSocket.open(*server.addr) do |socket|
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      3.times { run_all_threads }
      logged.must_include "connect #{tcp_addr}"
    end

    it 'logs messages received' do
      server.start
      tcp_addr = TCPSocket.open(*server.addr) do |socket|
        socket << 'TCP message'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      3.times { run_all_threads }
      logged.must_include "received #{tcp_addr} TCP message"
    end
  end
end end
