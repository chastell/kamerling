require_relative '../spec_helper'

module Kamerling describe Client do
  describe '.from_h' do
    it 'backtranslates host and port to addr' do
      Client.from_h(host: '127.0.0.1', port: 1981).addr
        .must_equal Addr['127.0.0.1', 1981]
    end
  end
end end
