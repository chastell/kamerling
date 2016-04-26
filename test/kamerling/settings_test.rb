# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/settings'

module Kamerling
  describe Settings do
    let(:args) { %w(--db db --host 0.0.0.0 --http 2009 --tcp 1981 --udp 1979) }
    let(:settings) { Settings.from_args(args) }

    describe '.from_args' do
      it 'has minimal defaults' do
        _(Settings.from_args([]).db).must_equal 'sqlite::memory:'
        _(Settings.from_args([]).host).must_equal '127.0.0.1'
      end

      it 'parses the passed settings' do
        settings = Settings.from_args(args)
        _(settings.db).must_equal 'db'
        _(settings.host).must_equal '0.0.0.0'
        _(settings.http).must_equal 2009
        _(settings.tcp).must_equal 1981
        _(settings.udp).must_equal 1979
      end
    end

    describe '.new' do
      it 'has minimal defaults' do
        _(Settings.new.db).must_equal 'sqlite::memory:'
        _(Settings.new.host).must_equal '127.0.0.1'
      end
    end

    describe '#db_conn' do
      it 'returns a db connection for repos' do
        _(Settings.new.db_conn).must_be_kind_of Sequel::Database
      end
    end

    describe '#http_addr' do
      it 'returns the HTTP server Addr' do
        _(Settings.from_args([]).http_addr).must_be_nil
        _(settings.http_addr).must_equal Addr['0.0.0.0', 2009, :TCP]
      end
    end

    describe '#server_addrs' do
      it 'returns the server Addrs' do
        _(Settings.from_args([]).server_addrs).must_equal({})
        _(Settings.from_args(args).server_addrs).must_equal(
          http: Addr['0.0.0.0', 2009, :TCP],
          tcp:  Addr['0.0.0.0', 1981, :TCP],
          udp:  Addr['0.0.0.0', 1979, :UDP],
        )
      end
    end
  end
end
