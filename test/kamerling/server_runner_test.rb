# frozen_string_literal: true

require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/server_runner'
require_relative '../../lib/kamerling/server/http'
require_relative '../../lib/kamerling/server/tcp'
require_relative '../../lib/kamerling/server/udp'

module Kamerling
  describe ServerRunner do
    let(:http)    { fake { Server::HTTP }                       }
    let(:tcp)     { fake { Server::TCP  }                       }
    let(:udp)     { fake { Server::UDP  }                       }
    let(:http_cl) { fake(as: :class) { Server::HTTP }           }
    let(:tcp_cl)  { fake(as: :class) { Server::TCP  }           }
    let(:udp_cl)  { fake(as: :class) { Server::UDP  }           }
    let(:classes) { { http: http_cl, tcp: tcp_cl, udp: udp_cl } }

    before do
      http_addr = Addr['0.0.0.0', 1234, :TCP]
      tcp_addr  = Addr['0.0.0.0', 3456, :TCP]
      udp_addr  = Addr['0.0.0.0', 5678, :UDP]
      stub(http_cl).new(addr: http_addr) { http }
      stub(tcp_cl).new(addr:  tcp_addr)  { tcp  }
      stub(udp_cl).new(addr:  udp_addr)  { udp  }
    end

    describe '.new' do
      it 'hooks to the given database' do
        args  = %w(--host 0.0.0.0 --db sqlite::memory:)
        db    = fake { Sequel::SQLite::Database }
        orm   = fake(:sequel, as: :class)
        stub(orm).connect('sqlite::memory:') { db }
        repos = fake(Repos, as: :class)
        ServerRunner.new args, classes: classes, orm: orm, repos: repos
        _(repos).must_have_received :db=, [db]
      end
    end

    describe '#join' do
      it 'joins all the created servers' do
        args = %w(--host 0.0.0.0 --http 1234)
        ServerRunner.new(args, classes: classes).join
        http.must_have_received :join, []
        tcp.wont_have_received :join,  []
        udp.wont_have_received :join,  []
      end
    end

    describe '#start' do
      it 'starts the servers based on the given command-line parameters' do
        args = %w(--host 0.0.0.0 --http 1234 --tcp 3456 --udp 5678)
        ServerRunner.new(args, classes: classes).start
        http.must_have_received :start, []
        tcp.must_have_received :start,  []
        udp.must_have_received :start,  []
      end

      it 'starts only the servers for which the port was given' do
        args = %w(--host 0.0.0.0 --http 1234)
        ServerRunner.new(args, classes: classes).start
        http.must_have_received :start, []
        tcp.wont_have_received :start,  []
        udp.wont_have_received :start,  []
      end

      it 'returns self' do
        server_runner = ServerRunner.new([], classes: classes)
        _(server_runner.start).must_equal server_runner
      end
    end
  end
end
