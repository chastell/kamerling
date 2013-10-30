require_relative '../../spec_helper'

module Kamerling describe Server::UDP do
  describe '.new' do
    it 'sets up an UDP server on the given host and port' do
      Server::UDP.new(host: '0.0.0.0', port: 2009).start
      UDPSocket.new.connect '0.0.0.0', 2009
    end

    it 'defaults to localhost' do
      Server::UDP.new.addr.host.must_equal '127.0.0.1'
    end

    it 'defaults to random, unused ports' do
      s1, s2 = Server::UDP.new.start, Server::UDP.new.start
      (1024..65_535).must_include s1.addr.port
      (1024..65_535).must_include s2.addr.port
      s1.addr.port.wont_equal s2.addr.port
    end
  end

  describe '#start' do
    it 'listens on an UDP port and passes the received input to the handler' do
      server = Server::UDP.new(handler: handler = fake(:handler)).start
      client = UDPSocket.new.tap { |s| s.connect(*server.addr) }
      client.send 'message', 0
      c_addr = Addr[client.addr[3], client.addr[1], :UDP]
      run_all_threads
      handler.must_have_received :handle, ['message', c_addr]
    end
  end

  describe '#addr' do
    it 'returns the server’s host + port as an UDP addr' do
      server = Server::UDP.new.start
      run_all_threads
      server.addr.must_equal Addr['127.0.0.1', server.addr.port, :UDP]
    end
  end

  describe 'logging' do
    let(:log)    { StringIO.new                                    }
    let(:logged) { log.tap(&:rewind).read                          }
    let(:logger) { Logger.new log                                  }
    let(:server) { Server::UDP.new host: '0.0.0.0', logger: logger }

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
