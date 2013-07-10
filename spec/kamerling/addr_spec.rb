require_relative '../spec_helper'

module Kamerling describe Addr do
  describe '#to_a' do
    it 'returns host + port for splat use' do
      splat = *Addr['127.0.0.1', 1981, :TCP]
      splat.must_equal ['127.0.0.1', 1981]
    end
  end
end end
