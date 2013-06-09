require_relative '../spec_helper'

module Kamerling describe Client do
  describe '#busy' do
    it 'defaults to false' do
      Client.new(addr: fake(:addr)).busy.must_equal false
    end
  end
end end
