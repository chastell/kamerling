require 'socket'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'

module Kamerling
  describe Addr do
    let(:addr) { Addr['localhost', 1981, :TCP] }

    describe '#connectable?' do
      it 'is a predicate whether the (TCP) address is connectable' do
        server = TCPServer.new(*addr)
        addr.must_be :connectable?
        server.close
        addr.wont_be :connectable?
      end
    end

    describe '#to_a' do
      it 'returns host + port for splat use' do
        splat = *addr
        splat.must_equal ['localhost', 1981]
      end
    end

    describe '#to_h' do
      it 'returns a Hash with Integer and String values' do
        addr.to_h.must_equal host: 'localhost', port: 1981, prot: 'TCP'
      end
    end

    describe '#to_s' do
      it 'returns the Addr in URI notation' do
        addr.to_s.must_equal 'tcp://localhost:1981'
      end
    end

    describe '#uri' do
      it 'returns and URI representation of the Addr' do
        addr.uri.must_equal URI.parse('tcp://localhost:1981')
      end
    end
  end
end
