require_relative '../../spec_helper'
require_relative '../../../lib/kamerling/server_runner/settings'

module Kamerling class ServerRunner; describe Settings do
  describe '.new' do
    it 'has sane defaults' do
      Settings.new([]).db.must_equal   'sqlite::memory:'
      Settings.new([]).host.must_equal '127.0.0.1'
    end

    it 'parses the passed settings' do
      args =  %w(--db db --host 0.0.0.0 --http 2009 --tcp 1981 --udp 1979)
      settings = Settings.new args
      settings.db.must_equal   'db'
      settings.host.must_equal '0.0.0.0'
      settings.http.must_equal 2009
      settings.tcp.must_equal  1981
      settings.udp.must_equal  1979
    end
  end
end end end
