require_relative '../spec_helper'

module Kamerling describe Server do
  let(:addrs) do
    {
      http: Addr['0.0.0.0', 2006, :TCP],
      tcp:  Addr['0.0.0.0', 1981, :TCP],
      udp:  Addr['0.0.0.0', 1979, :UDP],
    }
  end

  let(:server) { Server.new addrs: addrs }

  describe '#join' do
    it 'allows joining the TCP server thread' do
      server.must_respond_to :join
    end
  end

  describe '#start' do
    it 'starts all servers' do
      servers = {
        http: fake(Server::HTTP),
        tcp:  fake(Server::TCP),
        udp:  fake(Server::UDP),
      }
      Server.new(addrs: {}, servers: servers).start
      servers.values.each { |server| server.must_have_received :start, [] }
    end
  end

  describe '#stop' do
    it 'stops all servers' do
      servers = {
        http: fake(Server::HTTP),
        tcp:  fake(Server::TCP),
        udp:  fake(Server::UDP),
      }
      Server.new(addrs: {}, servers: servers).start.stop
      servers.values.each { |server| server.must_have_received :stop, [] }
    end
  end

  describe '#http_addr' do
    it 'returns the HTTP server’s Addr' do
      server.http_addr.must_equal Addr['0.0.0.0', server.http_addr.port, :TCP]
    end
  end

  describe '#tcp_addr' do
    it 'returns the TCP server’s Addr' do
      server.tcp_addr.must_equal Addr['0.0.0.0', server.tcp_addr.port, :TCP]
    end
  end

  describe '#udp_addr' do
    it 'returns the UDP server’s Addr' do
      server.udp_addr.must_equal Addr['0.0.0.0', server.udp_addr.port, :UDP]
    end
  end
end end
