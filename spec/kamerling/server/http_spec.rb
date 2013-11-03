require 'net/http'

require_relative '../../spec_helper'

module Kamerling describe Server::HTTP do
  describe '#start, #stop' do
    it 'starts/stops a HTTP server on the given host and port' do
      capture_io do
        server = Server::HTTP.new(host: '0.0.0.0', port: 2009).start
        400.times { run_all_threads }
        uri = URI.parse 'http://0.0.0.0:2009'
        Net::HTTP.get_response(uri).must_be_kind_of Net::HTTPSuccess
        server.stop
      end
    end
  end
end end
