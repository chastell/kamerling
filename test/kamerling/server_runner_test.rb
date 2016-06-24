# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/server/http'
require_relative '../../lib/kamerling/server/tcp'
require_relative '../../lib/kamerling/server/udp'
require_relative '../../lib/kamerling/server_runner'

module Kamerling
  describe ServerRunner do
    let(:http) { fake { Server::HTTP } }
    let(:tcp)  { fake { Server::TCP  } }
    let(:udp)  { fake { Server::UDP  } }

    describe '#join' do
      it 'joins all the created servers' do
        ServerRunner.new(servers: [http]).join
        http.must_have_received :join, []
        tcp.wont_have_received :join,  []
        udp.wont_have_received :join,  []
      end
    end

    describe '#start' do
      it 'starts the servers based on the given command-line parameters' do
        ServerRunner.new(servers: [http, tcp, udp]).start
        http.must_have_received :start, []
        tcp.must_have_received :start,  []
        udp.must_have_received :start,  []
      end

      it 'starts only the servers for which the port was given' do
        ServerRunner.new(servers: [http]).start
        http.must_have_received :start, []
        tcp.wont_have_received :start,  []
        udp.wont_have_received :start,  []
      end

      it 'returns self' do
        server_runner = ServerRunner.new
        _(server_runner.start).must_equal server_runner
      end
    end
  end
end
