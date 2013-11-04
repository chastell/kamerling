require_relative '../../spec_helper'

module Kamerling describe Server::HTTP do
  describe '#addr' do
    it 'returns the server’s host + port as a TCP addr' do
      capture_io do
        server = Server::HTTP.new.start
        400.times { run_all_threads }
        server.addr.must_equal Addr['127.0.0.1', server.addr.port, :TCP]
        server.stop
        2.times { run_all_threads }
      end
    end
  end

  describe '#start, #stop' do
    it 'starts/stops a HTTP server on the given host and port' do
      capture_io do
        server = Server::HTTP.new(host: '0.0.0.0', port: 2009).start
        400.times { run_all_threads }
        uri = URI.parse 'http://0.0.0.0:2009'
        Net::HTTP.get_response(uri).must_be_kind_of Net::HTTPSuccess
        server.stop
        2.times { run_all_threads }
      end
    end
  end
end end
