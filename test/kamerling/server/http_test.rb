# frozen_string_literal: true

require 'net/http'
require 'uri'
require_relative '../../test_helper'
require_relative '../../../lib/kamerling/server/http'

module Kamerling
  describe Server::HTTP do
    let(:addr) { Addr['localhost', 2009, :TCP] }

    describe '#addr' do
      it 'returns the server’s host + port as a TCP addr' do
        _(Server::HTTP.new(addr: addr).addr).must_equal addr
      end
    end

    describe '#start, #stop' do
      it 'starts/stops a HTTP server on the given host and port' do
        capture_io do
          server = Server::HTTP.new(addr: addr).start
          uri = URI.parse('http://localhost:2009')
          _(Net::HTTP.get_response(uri)).must_be_kind_of Net::HTTPSuccess
          server.stop
        end
      end
    end
  end
end
