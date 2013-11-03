require_relative '../spec_helper'

module Kamerling describe Server do
  let(:server) { Server.new host: '0.0.0.0' }

  describe '#join' do
    it 'allows joining the TCP server thread' do
      server.must_respond_to :join
    end
  end

  describe '#start, #stop' do
    it 'starts/stops HTTP, UDP and TCP servers on the given host and ports' do
      capture_io do
        server.start
        400.times { run_all_threads }
        uri = URI.parse "http://0.0.0.0:#{server.http_addr.port}"
        Net::HTTP.get_response(uri).must_be_kind_of Net::HTTPSuccess
        TCPSocket.open        '0.0.0.0', server.tcp_addr.port
        UDPSocket.new.connect '0.0.0.0', server.udp_addr.port
        server.stop
      end
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
