require_relative '../../spec_helper'

module Kamerling describe Server::HTTP do
  let(:addr) { Addr['0.0.0.0', 2009, :TCP] }

  describe '#addr' do
    it 'returns the server’s host + port as a TCP addr' do
      capture_io do
        server = Server::HTTP.new addr: addr
        server.addr.must_equal Addr['0.0.0.0', 2009, :TCP]
      end
    end
  end

  describe '#start, #stop' do
    it 'starts/stops a HTTP server on the given host and port' do
      capture_io do
        server = Server::HTTP.new(addr: addr).start
        400.times { run_all_threads }
        uri = URI.parse 'http://0.0.0.0:2009'
        Net::HTTP.get_response(uri).must_be_kind_of Net::HTTPSuccess
        server.stop
        4.times { run_all_threads }
      end
    end
  end
end end
