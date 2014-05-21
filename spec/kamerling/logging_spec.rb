require 'logger'
require 'socket'
require 'stringio'
require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/logging'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/net_dispatcher'
require_relative '../../lib/kamerling/server/tcp'
require_relative '../../lib/kamerling/server/udp'

module Kamerling describe Logging do
  let(:logged)     { stream.tap(&:rewind).read                           }
  let(:logger)     { Logger.new stream                                   }
  let(:stream)     { StringIO.new                                        }
  let(:tcp_server) { Server::TCP.new addr: Addr['localhost', 1981, :TCP] }
  let(:udp_server) { Server::UDP.new addr: Addr['localhost', 1979, :UDP] }

  before do
    Logging.log_to logger
    tcp_server.start
    udp_server.start
  end

  after do
    tcp_server.stop
    udp_server.stop
  end

  describe '.log_to' do
    it 'logs TCP server starts' do
      logged.must_include 'start localhost:1981 (TCP)'
    end

    it 'logs TCP server stops' do
      tcp_server.stop
      logged.must_include 'stop localhost:1981 (TCP)'
    end

    it 'logs TCP server connects' do
      tcp_addr = TCPSocket.open(*tcp_server.addr) do |socket|
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      logged.must_include "connect #{tcp_addr}"
    end

    it 'logs TCP server receives' do
      tcp_addr = TCPSocket.open(*tcp_server.addr) do |socket|
        socket << 'PING'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      logged.must_include "received #{tcp_addr} 50 49 4e 47"
    end

    it 'logs TCP unknown message types' do
      tcp_addr = TCPSocket.open(*tcp_server.addr) do |socket|
        socket << 'foo'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      logged.must_include "received #{tcp_addr} unknown message type"
    end

    it 'logs UDP server starts' do
      logged.must_include 'start localhost:1979 (UDP)'
    end

    it 'logs UDP server stops' do
      udp_server.stop
      logged.must_include 'stop localhost:1979 (UDP)'
    end

    it 'logs UDP server connects' do
      udp_client = UDPSocket.new
      udp_client.send 'PING', 0, *udp_server.addr
      udp_addr = Addr['127.0.0.1', udp_client.addr[1], :UDP]
      run_all_threads
      logged.must_include "connect #{udp_addr}"
    end

    it 'logs UDP server receives' do
      udp_client = UDPSocket.new
      udp_client.send 'PING', 0, *udp_server.addr
      udp_addr = Addr['127.0.0.1', udp_client.addr[1], :UDP]
      run_all_threads
      logged.must_include "received #{udp_addr} 50 49 4e 47"
    end

    it 'logs UDP unknown message types' do
      udp_client = UDPSocket.new
      udp_client.send 'foo', 0, *udp_server.addr
      udp_addr = Addr['127.0.0.1', udp_client.addr[1], :UDP]
      run_all_threads
      logged.must_include "received #{udp_addr} unknown message type"
    end

    it 'logs packet dispatches' do
      server = UDPSocket.new.tap { |s| s.bind '127.0.0.1', 0 }
      addr   = Addr[server.addr[3], server.addr[1], :UDP]
      NetDispatcher.dispatch addr, Message.new('PING')
      logged.must_include "sent #{addr} 50 49 4e 47"
    end
  end
end end
