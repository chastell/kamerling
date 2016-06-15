# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/settings'

module Kamerling
  describe Settings do
    describe '#servers' do
      it 'returns the requested servers' do
        _(Settings.new.servers).must_equal []
        settings = Settings.new(host: '0.0.0.0', http: 2009, tcp: 1981,
                                udp: 1979)
        _(settings.servers).must_equal [
          Server::HTTP.new(addr: Addr['0.0.0.0', 2009, :TCP]),
          Server::TCP.new(addr:  Addr['0.0.0.0', 1981, :TCP]),
          Server::UDP.new(addr:  Addr['0.0.0.0', 1979, :UDP]),
        ]
      end
    end
  end
end
