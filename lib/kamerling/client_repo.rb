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
      db[:registrations].join(:clients, uuid: :client_uuid)
                        .where(busy: false, project_uuid: project_uuid).all
                        .map(&Client.method(:new))
    end

    def for_project(project_uuid)
      db[:registrations].join(:clients, uuid: :client_uuid)
                        .where(project_uuid: project_uuid).all
                        .map(&Client.method(:new))
    end

    private

    attr_reader :db
  end
end
