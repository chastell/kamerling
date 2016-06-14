# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/settings'

module Kamerling
  describe Settings do
    describe '#servers' do
      it 'returns the requested servers' do
        _(Settings.new.servers).must_equal []
        ENV['HOST'] = '0.0.0.0'
        ENV['HTTP'] = '2009'
        ENV['TCP']  = '1981'
        ENV['UDP']  = '1979'
        _(Settings.new.servers).must_equal [
          Server::HTTP.new(addr: Addr['0.0.0.0', 2009, :TCP]),
          Server::TCP.new(addr:  Addr['0.0.0.0', 1981, :TCP]),
          Server::UDP.new(addr:  Addr['0.0.0.0', 1979, :UDP]),
        ]
      end
    end
  end
end
