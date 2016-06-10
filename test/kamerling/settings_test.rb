# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/settings'

module Kamerling
  describe Settings do
    let(:args) { %w(--host 0.0.0.0 --http 2009 --tcp 1981 --udp 1979) }
    let(:settings) { Settings.from_args(args) }

    describe '.from_args' do
      it 'has minimal defaults' do
        _(Settings.from_args([]).host).must_equal '127.0.0.1'
      end

      it 'parses the passed settings' do
        settings = Settings.from_args(args)
        _(settings.host).must_equal '0.0.0.0'
        _(settings.http).must_equal 2009
        _(settings.tcp).must_equal 1981
        _(settings.udp).must_equal 1979
      end
    end

    describe '.new' do
      it 'has minimal defaults' do
        _(Settings.new.host).must_equal '127.0.0.1'
      end
    end

    describe '#servers' do
      it 'returns the requested servers' do
        _(Settings.from_args([]).servers).must_equal []
        _(Settings.from_args(args).servers).must_equal [
          Server::HTTP.new(addr: Addr['0.0.0.0', 2009, :TCP]),
          Server::TCP.new(addr:  Addr['0.0.0.0', 1981, :TCP]),
          Server::UDP.new(addr:  Addr['0.0.0.0', 1979, :UDP]),
        ]
      end
    end
  end
end
