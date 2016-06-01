# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/dispatch_repo'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/registration_repo'
require_relative '../../lib/kamerling/result_repo'
require_relative '../../lib/kamerling/settings'
require_relative '../../lib/kamerling/task_repo'

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

    describe '#client_repo' do
      it 'returns a ClientRepo for the db connection' do
        _(Settings.new.client_repo).must_be_kind_of ClientRepo
      end
    end

    describe '#dispatch_repo' do
      it 'returns a DispatchRepo for the db connection' do
        _(Settings.new.dispatch_repo).must_be_kind_of DispatchRepo
      end
    end

    describe '#project_repo' do
      it 'returns a ProjectRepo for the db connection' do
        _(Settings.new.project_repo).must_be_kind_of ProjectRepo
      end
    end

    describe '#registration_repo' do
      it 'returns a RegistrationRepo for the db connection' do
        _(Settings.new.registration_repo).must_be_kind_of RegistrationRepo
      end
    end

    describe '#result_repo' do
      it 'returns a ResultRepo for the db connection' do
        _(Settings.new.result_repo).must_be_kind_of ResultRepo
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

    describe '#task_repo' do
      it 'returns a TaskRepo for the db connection' do
        _(Settings.new.task_repo).must_be_kind_of TaskRepo
      end
    end
  end
end
