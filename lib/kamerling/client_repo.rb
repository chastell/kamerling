# frozen_string_literal: true

require_relative 'client'
require_relative 'mapper'
require_relative 'new_repo'
require_relative 'settings'

module Kamerling
  class ClientRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @db    = db
      @klass = Client
      @table = db[:clients]
    end

    def free_for_project(project_uuid)
      scoped_clients(project_uuid: project_uuid, busy: false)
    end

    def for_project(project_uuid)
      scoped_clients(project_uuid: project_uuid)
    end

    private

    attr_reader :db

    def scoped_clients(scope)
      db[:registrations].join(:clients, uuid: :client_uuid).where(scope).all
                        .map(&Client.method(:new))
    end
  end
end
