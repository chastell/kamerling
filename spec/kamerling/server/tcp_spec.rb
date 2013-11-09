require_relative '../../spec_helper'

module Kamerling describe Server::TCP do
  let(:addr) { Addr['localhost', 1981, :TCP] }

  describe '#addr' do
    it 'returns the server’s host + port as a TCP addr' do
      Server::TCP.new(addr: addr).addr.must_equal addr
    end
  end

  describe '#start' do
    it 'listens on a TCP port and passes received inputs to the handler' do
      server = Server::TCP.new addr: addr, handler: handler = fake(:handler)
      server.start
      s_addr_foo = TCPSocket.open(*server.addr) do |socket|
        socket << 'foo'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      s_addr_bar = TCPSocket.open(*server.addr) do |socket|
        socket << 'bar'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      server.stop
      handler.must_have_received :handle, ['foo', s_addr_foo]
      handler.must_have_received :handle, ['bar', s_addr_bar]
    end
  end

  describe '#stop' do
    it 'stops the server' do
      server = Server::TCP.new(addr: addr).start
      server.stop
      -> { TCPSocket.open(*addr).close }.must_raise Errno::ECONNREFUSED
    end
  end

  describe 'logging' do
    let(:log)    { StringIO.new                               }
    let(:logged) { log.tap(&:rewind).read                     }
    let(:logger) { Logger.new log                             }
    let(:server) { Server::TCP.new addr: addr, logger: logger }

    before { server.start }
    after  { server.stop  }

    it 'logs server starts' do
      logged.must_include "start #{server.addr}"
    end

    it 'logs server connects' do
      tcp_addr = TCPSocket.open(*server.addr) do |socket|
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      logged.must_include "connect #{tcp_addr}"
    end

    it 'logs messages received' do
      tcp_addr = TCPSocket.open(*server.addr) do |socket|
        socket << 'TCP message'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      logged.must_include "received #{tcp_addr} TCP message"
    end
  end
end end
