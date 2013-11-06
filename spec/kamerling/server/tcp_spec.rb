require_relative '../../spec_helper'

module Kamerling describe Server::TCP do
  describe '.new' do
    it 'sets up a TCP server on the given host and port' do
      Server::TCP.new(host: '0.0.0.0', port: 1981).start
      TCPSocket.open '0.0.0.0', 1981
    end

    it 'defaults to localhost' do
      Server::TCP.new(port: 1986).addr.host.must_equal '127.0.0.1'
    end
  end

  describe '#addr' do
    it 'returns the server’s host + port as a TCP addr' do
      server = Server::TCP.new port: 1985
      server.addr.must_equal Addr['127.0.0.1', server.addr.port, :TCP]
    end
  end

  describe '#start' do
    it 'listens on a TCP port and passes the received input to the handler' do
      server = Server::TCP.new handler: handler = fake(:handler), port: 1984
      server.start
      s_addr = TCPSocket.open(*server.addr) do |socket|
        socket << 'message'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      4.times { run_all_threads }
      handler.must_have_received :handle, ['message', s_addr]
    end
  end

  describe '#stop' do
    it 'stops the server' do
      tcp  = Server::TCP.new(port: 1983).start
      addr = tcp.addr
      tcp.stop
      run_all_threads
      -> { TCPSocket.open(*addr) }.must_raise Errno::ECONNREFUSED
    end
  end

  describe 'logging' do
    let(:log)    { StringIO.new                               }
    let(:logged) { log.tap(&:rewind).read                     }
    let(:logger) { Logger.new log                             }
    let(:server) { Server::TCP.new logger: logger, port: 1982 }

    after do
      server.stop
      run_all_threads
    end

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
      4.times { run_all_threads }
      logged.must_include "connect #{tcp_addr}"
    end

    it 'logs messages received' do
      server.start
      tcp_addr = TCPSocket.open(*server.addr) do |socket|
        socket << 'TCP message'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      4.times { run_all_threads }
      logged.must_include "received #{tcp_addr} TCP message"
    end
  end
end end
