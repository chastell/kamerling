require_relative '../spec_helper'

module Kamerling describe Addr do
  describe '#connectable?' do
    it 'is a predicate whether the (TCP) address is connectable' do
      addr   = Addr['localhost', 1981, :TCP]
      server = TCPServer.new(*addr)
      addr.must_be :connectable?
      server.close
      addr.wont_be :connectable?
    end
  end

  describe '#to_a' do
    it 'returns host + port for splat use' do
      splat = *Addr['127.0.0.1', 1981, :TCP]
      splat.must_equal ['127.0.0.1', 1981]
    end
  end

  describe '#to_s' do
    it 'returns the Addr in ‘host:port (protocol)’ notation' do
      Addr['127.0.0.1', 1981, :UDP].to_s.must_equal '127.0.0.1:1981 (UDP)'
    end
  end
end end
