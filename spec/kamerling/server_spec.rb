require_relative '../spec_helper'

module Kamerling describe Server do
  describe '.new' do
    it 'starts a server on the given host and ports' do
      Server.new(host: '0.0.0.0', tcp_port: 1981, udp_port: 1979).start
      TCPSocket.open '0.0.0.0', 1981
      UDPSocket.new.connect '0.0.0.0', 1979
    end

    it 'defaults to localhost' do
      Server.new.tcp_addr.host.must_equal '127.0.0.1'
    end

    it 'defaults to random, unused ports' do
      s1, s2 = Server.new.start, Server.new.start
      (1024..65_535).must_include s1.tcp_addr.port
      (1024..65_535).must_include s2.tcp_addr.port
      (1024..65_535).must_include s1.udp_addr.port
      (1024..65_535).must_include s2.udp_addr.port
      s1.tcp_addr.port.wont_equal s2.tcp_addr.port
      s1.udp_addr.port.wont_equal s2.udp_addr.port
    end
  end

  describe '#join' do
    it 'allows joining the server thread' do
      Server.new.must_respond_to :join
    end
  end

  describe '#start' do
    it 'listens on a TCP port and passes the received input to the handler' do
      server = Server.new(handler: handler = fake(:handler)).start
      s_addr = TCPSocket.open(*server.tcp_addr) do |socket|
        socket << 'message'
        Addr[*socket.local_address.ip_unpack, :TCP]
      end
      2.times { run_all_threads }
      handler.must_have_received :handle, ['message', s_addr]
    end

    it 'listens on an UDP port and passes the received input to the handler' do
      server = Server.new(handler: handler = fake(:handler)).start
      client = UDPSocket.new.tap { |s| s.connect(*server.udp_addr) }
      client.send 'message', 0
      c_addr = Addr[client.addr[3], client.addr[1], :UDP]
      run_all_threads
      handler.must_have_received :handle, ['message', c_addr]
    end
  end

  describe '#tcp_addr' do
    it 'returns the server’s host + port as a TCP addr' do
      server = Server.new
      server.tcp_addr.must_equal Addr['127.0.0.1', server.tcp_addr.port, :TCP]
    end
  end

  describe '#udp_addr' do
    it 'returns the server’s host + port as an UDP addr' do
      server = Server.new.start
      run_all_threads
      server.udp_addr.must_equal Addr['127.0.0.1', server.udp_addr.port, :UDP]
    end
  end
end end
