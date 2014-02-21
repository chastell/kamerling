require_relative '../spec_helper'

module Kamerling describe Logging do
  let(:logged) { stream.tap(&:rewind).read }
  let(:logger) { Logger.new stream         }
  let(:stream) { StringIO.new              }

  before { Logging.new logger: logger }

  describe '.new' do
    it 'logs TCP server starts' do
      Server::TCP.new(addr: Addr['localhost', 1981, :TCP]).start.stop
      logged.must_include 'start localhost:1981 (TCP)'
    end

    it 'logs TCP server stops' do
      Server::TCP.new(addr: Addr['localhost', 1981, :TCP]).start.stop
      logged.must_include 'stop localhost:1981 (TCP)'
    end

    it 'logs TCP server connects' do
      server = Server::TCP.new(addr: Addr['localhost', 1981, :TCP])
      server.start
      tcp_addr = TCPSocket.open(*server.addr) do |socket|
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      run_all_threads
      server.stop
      logged.must_include "connect #{tcp_addr}"
    end
  end
end end
