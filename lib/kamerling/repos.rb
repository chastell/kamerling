# frozen_string_literal: true

require 'sequel'
require_relative 'client_repo'
require_relative 'project_repo'
require_relative 'result_repo'
require_relative 'task_repo'
require_relative 'uuid'

module Kamerling
  class Repos
    def initialize(conn_str = ENV.fetch('DB', 'sqlite::memory:'), db: nil)
      @db = db || Sequel.connect(conn_str)
    end

    def client_repo
      @client_repo ||= ClientRepo.new(db)
    end

    def project_repo
      @project_repo ||= ProjectRepo.new(db)
    end

    def record_dispatch(client:, project:, task:)
      db[:dispatches] << client.addr.to_h.merge(client_id: client.id,
                                                dispatched_at: Time.now.utc,
                                                id: UUID.new,
                                                project_id: project.id,
                                                task_id: task.id)
    end

    def record_registration(addr:, client:, project:)
      db[:registrations] << addr.to_h.merge(client_id: client.id,
                                            id: UUID.new,
                                            project_id: project.id,
                                            registered_at: Time.now.utc)
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
