# frozen_string_literal: true

require_relative 'client'
require_relative 'new_repo'
require_relative 'project'
require_relative 'task'

module Kamerling
  class ProjectRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @db    = db
      @klass = Project
      @table = db[:projects]
    end

    def all
      table.all.map(&Project.method(:new))
    end

    def fetch_with_clients_and_tasks(uuid)
      clients = client_hashes(uuid).map(&Client.method(:new))
      tasks   = task_hashes(uuid).map(&Task.method(:new))
      klass.new(table[uuid: uuid].merge(clients: clients, tasks: tasks))
    end

    private

    attr_reader :db, :table

    def client_hashes(uuid)
      db[:registrations].join(:clients, uuid: :client_uuid)
                        .where(project_uuid: uuid).all
    end

    def task_hashes(uuid)
      db[:tasks].where(project_uuid: uuid).all
    end
  end
end
