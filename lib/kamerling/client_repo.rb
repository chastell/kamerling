# frozen_string_literal: true

require_relative 'client'
require_relative 'mapper'
require_relative 'repo'
require_relative 'settings'

module Kamerling
  class ClientRepo < Repo
    def initialize(db = Settings.new.db_conn)
      @db    = db
      @klass = Client
      @table = db[:clients]
    end

    def free_for_project(project)
      scoped_clients(project_uuid: project.uuid, busy: false)
    end

    def for_project(project)
      scoped_clients(project_uuid: project.uuid)
    end

    private

    attr_reader :db

    def scoped_clients(scope)
      db[:registrations].join(:clients, uuid: :client_uuid).where(scope).all
                        .map(&Client.method(:new))
    end
  end
end
