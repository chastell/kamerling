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
    def initialize(conn_str = ENV.fetch('DB', 'sqlite::memory:'), db: nil)
      @db = db || Sequel.connect(conn_str)
    end

    def client_repo
      @client_repo ||= ClientRepo.new(db)
    end

    def dispatch_repo
      @dispatch_repo ||= DispatchRepo.new(db)
    end

    def project_repo
      @project_repo ||= ProjectRepo.new(db)
    end

    def record_dispatch(client:, project:, task:)
      db[:dispatches] << Dispatch.new(addr: client.addr, client: client,
                                      project: project, task: task).to_h
    end

    def registration_repo
      @registration_repo ||= RegistrationRepo.new(db)
    end

    def result_repo
      @result_repo ||= ResultRepo.new(db)
    end

    def task_repo
      @task_repo ||= TaskRepo.new(db)
    end

    private

    attr_reader :db
  end
end
