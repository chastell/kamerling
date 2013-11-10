require_relative '../spec_helper'

module Kamerling describe Server do
  let(:addrs) do
    {
      http: Addr['0.0.0.0', 2006, :TCP],
      tcp:  Addr['0.0.0.0', 1981, :TCP],
      udp:  Addr['0.0.0.0', 1979, :UDP],
    }
  end

  let(:server)  { Server.new addrs: addrs }
  let(:servers) { [fake(Server::HTTP), fake(Server::TCP), fake(Server::UDP)] }

  describe '#start' do
    it 'starts all servers' do
      Server.new(addrs: {}, servers: servers).start
      servers.each { |server| server.must_have_received :start, [] }
    end
  end

  describe '#stop' do
    it 'stops all servers' do
      Server.new(addrs: {}, servers: servers).start.stop
      servers.each { |server| server.must_have_received :stop, [] }
    end
  end
end end
