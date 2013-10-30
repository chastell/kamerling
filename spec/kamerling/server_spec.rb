require_relative '../spec_helper'

module Kamerling describe Server do
  describe '.new' do
    it 'starts UDP and TCP servers on the given host and ports' do
      Server.new(host: '0.0.0.0', tcp_port: 1981, udp_port: 1979).start
      TCPSocket.open '0.0.0.0', 1981
      UDPSocket.new.connect '0.0.0.0', 1979
    end
  end

  describe '#join' do
    it 'allows joining the TCP server thread' do
      Server.new.must_respond_to :join
    end
  end

  describe '#start' do
    it 'starts UDP and TCP servers' do
      tcp = fake Server::TCP
      udp = fake Server::UDP
      Server.new(tcp: tcp, udp: udp).start
      tcp.must_have_received :start, []
      udp.must_have_received :start, []
    end
  end

  describe '#tcp_addr' do
    it 'returns the TCP server’s Addr' do
      tcp = fake Server::TCP, addr: addr = fake(:addr)
      Server.new(tcp: tcp).tcp_addr.must_equal addr
    end
  end

  describe '#udp_addr' do
    it 'returns the UDP server’s Addr' do
      udp = fake Server::UDP, addr: addr = fake(:addr)
      Server.new(udp: udp).udp_addr.must_equal addr
    end
  end
end end
