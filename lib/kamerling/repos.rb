# frozen_string_literal: true

require 'sequel'
require_relative 'client_repo'
require_relative 'dispatch'
require_relative 'dispatch_repo'
require_relative 'project_repo'
require_relative 'registration_repo'
require_relative 'result_repo'
require_relative 'task_repo'

module Kamerling
  class Repos
    def initialize(db = ENV.fetch('DB', 'sqlite::memory:'))
      @db_conn = Sequel.connect(db)
    end

    def client_repo
      @client_repo ||= ClientRepo.new(db_conn)
    end

    def dispatch_repo
      @dispatch_repo ||= DispatchRepo.new(db_conn)
    end

    def project_repo
      @project_repo ||= ProjectRepo.new(db_conn)
    end

    def record_dispatch(client:, project:, task:)
      dispatch_repo << Dispatch.new(addr: client.addr, client: client,
                                    project: project, task: task)
    end

    def registration_repo
      @registration_repo ||= RegistrationRepo.new(db_conn)
    end

    def result_repo
      @result_repo ||= ResultRepo.new(db_conn)
    end

    def task_repo
      @task_repo ||= TaskRepo.new(db_conn)
    end

    private

    attr_reader :db_conn
  end
end
