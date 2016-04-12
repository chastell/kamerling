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
    describe '.client_repo' do
      it 'returns a ClientRepo' do
        _(Repos.client_repo).must_be_kind_of ClientRepo
      end
    end

    describe '.dispatch_repo' do
      it 'returns a DispatchRepo' do
        _(Repos.dispatch_repo).must_be_kind_of DispatchRepo
      end
    end

    describe '.project_repo' do
      it 'returns a ProjectRepo' do
        _(Repos.project_repo).must_be_kind_of ProjectRepo
      end
    end

    describe '.registration_repo' do
      it 'returns a RegistrationRepo' do
        _(Repos.registration_repo).must_be_kind_of RegistrationRepo
      end
    end

    describe '.result_repo' do
      it 'returns a ResultRepo' do
        _(Repos.result_repo).must_be_kind_of ResultRepo
      end
    end

    describe '.task_repo' do
      it 'returns a TaskRepo' do
        _(Repos.task_repo).must_be_kind_of TaskRepo
      end
    end
  end
end
