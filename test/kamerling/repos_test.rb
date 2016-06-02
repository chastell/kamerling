# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/dispatch_repo'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/registration_repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/result_repo'
require_relative '../../lib/kamerling/task_repo'

module Kamerling
  describe Repos do
    describe '#client_repo' do
      it 'returns a ClientRepo for the db connection' do
        _(Repos.new.client_repo).must_be_kind_of ClientRepo
      end
    end

    describe '#dispatch_repo' do
      it 'returns a DispatchRepo for the db connection' do
        _(Repos.new.dispatch_repo).must_be_kind_of DispatchRepo
      end
    end

    describe '#project_repo' do
      it 'returns a ProjectRepo for the db connection' do
        _(Repos.new.project_repo).must_be_kind_of ProjectRepo
      end
    end

    describe '#registration_repo' do
      it 'returns a RegistrationRepo for the db connection' do
        _(Repos.new.registration_repo).must_be_kind_of RegistrationRepo
      end
    end

    describe '#result_repo' do
      it 'returns a ResultRepo for the db connection' do
        _(Repos.new.result_repo).must_be_kind_of ResultRepo
      end
    end

    describe '#task_repo' do
      it 'returns a TaskRepo for the db connection' do
        _(Repos.new.task_repo).must_be_kind_of TaskRepo
      end
    end
  end
end
