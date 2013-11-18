require_relative '../spec_helper'

module Kamerling describe Server do
  let(:servers) { [fake(Server::HTTP), fake(Server::TCP), fake(Server::UDP)] }

  describe '#join' do
    it 'joins all servers' do
      Server.new(addrs: {}, servers: servers).join
      servers.each { |server| server.must_have_received :join, [] }
    end
  end

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
