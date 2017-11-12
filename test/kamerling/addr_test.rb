require 'socket'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'

module Kamerling
  describe Addr do
    let(:addr) { Addr['localhost', 1981, :TCP] }

    describe '#connectable?' do
      it 'is a predicate whether the (TCP) address is connectable' do
        server = TCPServer.new(*addr)
        assert addr.connectable?
        server.close
        refute addr.connectable?
      end
    end

    describe '#to_a' do
      it 'returns host + port for splat use' do
        splat = *addr
        _(splat).must_equal ['localhost', 1981]
      end
    end

    describe '#to_h' do
      it 'returns a Hash with Integer and String values' do
        _(addr.to_h).must_equal host: 'localhost', port: 1981, prot: 'TCP'
      end
    end

    describe '#to_s' do
      it 'returns the Addr in URI notation' do
        _(addr.to_s).must_equal 'tcp://localhost:1981'
      end
    end
  end
end
