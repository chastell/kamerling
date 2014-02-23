require_relative '../spec_helper'

module Kamerling describe Logging do
  let(:logged)     { stream.tap(&:rewind).read                           }
  let(:logger)     { Logger.new stream                                   }
  let(:stream)     { StringIO.new                                        }
  let(:tcp_server) { Server::TCP.new addr: Addr['localhost', 1981, :TCP] }
  let(:udp_server) { Server::UDP.new addr: Addr['localhost', 1979, :UDP] }

  before do
    Logging.new logger: logger
    tcp_server.start
    udp_server.start
  end

  after do
    tcp_server.stop
    udp_server.stop
  end

  describe '.new' do
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
      logged.must_include "received #{tcp_addr} PING"
    end

    it 'logs UDP server starts' do
      logged.must_include 'start localhost:1979 (UDP)'
    end
  end
end end
