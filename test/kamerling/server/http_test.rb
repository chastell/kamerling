# frozen_string_literal: true

require 'net/http'
require 'uri'
require_relative '../../test_helper'
require_relative '../../../lib/kamerling/server/http'

module Kamerling
  describe Server::HTTP do
    let(:addr) { Addr['localhost', 2009, :TCP] }
    let(:http) { Server::HTTP.new(addr: addr)  }

    describe '#==' do
      it 'compares servers by their addresses' do
        assert http == Server::HTTP.new(addr: Addr['localhost', 2009, :TCP])
        refute http == Server::HTTP.new(addr: Addr['localhost', 2010, :TCP])
      end
    end

    describe '#addr' do
      it 'returns the server’s host + port as a TCP addr' do
        _(http.addr).must_equal addr
      end
    end

    describe '#start, #stop' do
      it 'starts/stops a HTTP server on the given host and port' do
        capture_io do
          server = http.start
          uri = URI.parse('http://localhost:2009')
          _(Net::HTTP.get_response(uri)).must_be_kind_of Net::HTTPSuccess
          server.stop
        end
      end
    end
  end
end
