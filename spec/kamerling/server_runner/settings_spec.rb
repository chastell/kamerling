require_relative '../../spec_helper'
require_relative '../../../lib/kamerling/addr'
require_relative '../../../lib/kamerling/server_runner/settings'

module Kamerling class ServerRunner; describe Settings do
  let(:args) { %w(--db db --host 0.0.0.0 --http 2009 --tcp 1981 --udp 1979) }

  describe '.new' do
    it 'has sane defaults' do
      Settings.new([]).db.must_equal   'sqlite::memory:'
      Settings.new([]).host.must_equal '127.0.0.1'
    end

    it 'parses the passed settings' do
      settings = Settings.new args
      settings.db.must_equal   'db'
      settings.host.must_equal '0.0.0.0'
      settings.http.must_equal 2009
      settings.tcp.must_equal  1981
      settings.udp.must_equal  1979
    end
  end

  describe '#server_addrs' do
    it 'returns the server Addrs' do
      Settings.new([]).server_addrs.must_equal({})
      Settings.new(args).server_addrs.must_equal(
        http: Addr['0.0.0.0', 2009, :TCP],
        tcp:  Addr['0.0.0.0', 1981, :TCP],
        udp:  Addr['0.0.0.0', 1979, :UDP],
      )
    end
  end
end end end
