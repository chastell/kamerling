# frozen_string_literal: true

require_relative 'client'
require_relative 'repo'

module Kamerling
  class ClientRepo < Repo
    def free_for_project(project)
      scoped_clients(project_id: project.id, busy: false)
    end

    def for_project(project)
      scoped_clients(project_id: project.id)
    end

    private

    def klass
      Client
    end

    def scoped_clients(scope)
      db[:registrations].join(:clients, id: :client_id).where(scope).all
                        .map(&Client.method(:new))
    end

    def table
      db[:clients]
    end
  end
end
