require_relative '../spec_helper'

module Kamerling describe Addr do
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

  describe '#to_s' do
    it 'returns the Addr in ‘host:port (protocol)’ notation' do
      addr.to_s.must_equal 'localhost:1981 (TCP)'
    end
  end
end end
