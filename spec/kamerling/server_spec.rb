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
end end
