# frozen_string_literal: true

require_relative 'client_repo'
require_relative 'dispatch_repo'
require_relative 'project_repo'
require_relative 'registration_repo'
require_relative 'result_repo'
require_relative 'task_repo'

module Kamerling
  class Repos
    class << self
      def client_repo
        @client_repo ||= ClientRepo.new
      end

      def dispatch_repo
        @dispatch_repo ||= DispatchRepo.new
      end

      def project_repo
        @project_repo ||= ProjectRepo.new
      end

      def registration_repo
        @registration_repo ||= RegistrationRepo.new
      end

      def result_repo
        @result_repo ||= ResultRepo.new
      end

      def task_repo
        @task_repo ||= TaskRepo.new
      end
    end
  end
end
