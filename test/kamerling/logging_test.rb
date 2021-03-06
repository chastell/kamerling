require 'logger'
require 'socket'
require 'stringio'
require_relative '../test_helper'
require_relative '../../lib/kamerling/logging'
require_relative '../../lib/kamerling/net_dispatcher'
require_relative '../../lib/kamerling/server/tcp'
require_relative '../../lib/kamerling/server/udp'
require_relative '../../lib/kamerling/tcp_addr'
require_relative '../../lib/kamerling/udp_addr'

module Kamerling
  describe Logging do
    let(:logged)     { stream.tap(&:rewind).read                         }
    let(:logger)     { Logger.new(stream)                                }
    let(:stream)     { StringIO.new                                      }
    let(:tcp_server) { Server::TCP.new(addr: TCPAddr['localhost', 1981]) }
    let(:udp_server) { Server::UDP.new(addr: UDPAddr['localhost', 1979]) }
    let(:udp_client) { UDPSocket.new                                     }

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
        _(logged).must_include 'start tcp://localhost:1981'
      end

      it 'logs TCP server stops' do
        tcp_server.stop
        _(logged).must_include 'stop tcp://localhost:1981'
      end

      it 'logs TCP server connects' do
        tcp_addr = TCPSocket.open(*tcp_server.addr) do |socket|
          TCPAddr[*socket.local_address.ip_unpack]
        end
        run_all_threads
        _(logged).must_include "connect #{tcp_addr}"
      end

      it 'logs TCP server receives' do
        tcp_addr = TCPSocket.open(*tcp_server.addr) do |socket|
          socket << 'PING'
          TCPAddr[*socket.local_address.ip_unpack]
        end
        run_all_threads
        _(logged).must_include "received #{tcp_addr} 50 49 4e 47"
      end

      it 'logs TCP unknown message types' do
        tcp_addr = TCPSocket.open(*tcp_server.addr) do |socket|
          socket << 'foo'
          TCPAddr[*socket.local_address.ip_unpack]
        end
        run_all_threads
        _(logged).must_include "received #{tcp_addr} unknown message type"
      end

      it 'logs UDP server starts' do
        _(logged).must_include 'start udp://localhost:1979'
      end

      it 'logs UDP server stops' do
        udp_server.stop
        _(logged).must_include 'stop udp://localhost:1979'
      end

      it 'logs UDP server connects' do
        100.times { udp_client.send 'PING', 0, *udp_server.addr }
        udp_addr = UDPAddr['127.0.0.1', udp_client.addr[1]]
        run_all_threads
        _(logged).must_include "connect #{udp_addr}"
      end

      it 'logs UDP server receives' do
        run_all_threads
        100.times { udp_client.send 'PING', 0, *udp_server.addr }
        udp_addr = UDPAddr['127.0.0.1', udp_client.addr[1]]
        run_all_threads
        _(logged).must_include "received #{udp_addr} 50 49 4e 47"
      end

      it 'logs UDP unknown message types' do
        100.times { udp_client.send 'foo', 0, *udp_server.addr }
        udp_addr = UDPAddr['127.0.0.1', udp_client.addr[1]]
        run_all_threads
        _(logged).must_include "received #{udp_addr} unknown message type"
      end

      it 'logs packet dispatches' do
        server = UDPSocket.new.tap { |sock| sock.bind '127.0.0.1', 0 }
        addr   = UDPAddr[server.addr[3], server.addr[1]]
        NetDispatcher.dispatch 'PING', addr: addr
        _(logged).must_include "sent #{addr} 50 49 4e 47"
      end
    end
  end
end
