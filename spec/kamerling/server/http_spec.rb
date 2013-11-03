require 'net/http'

require_relative '../../spec_helper'

module Kamerling describe Server::HTTP do
  describe '#start, #stop' do
    it 'starts/stops a HTTP server on the given host and port' do
      response = nil
      capture_io do
        server = Server::HTTP.new(host: '0.0.0.0', port: 2009).start
        400.times { run_all_threads }
        response = Net::HTTP.get_response URI.parse 'http://0.0.0.0:2009'
        server.stop
      end
      response.must_be_kind_of Net::HTTPSuccess
    end
  end
end end
