# frozen_string_literal: true

require_relative 'addr'
require_relative 'client'
require_relative 'entity'
require_relative 'project'

module Kamerling
  class Registration < Entity
    attrs addr: Addr, client: Client, project: Project, registered_at: Time
    defaults registered_at: -> (*) { Time.now.utc }

    def new_to_h
      addr.to_h.merge(client_uuid: client.uuid, project_uuid: project.uuid,
                      registered_at: registered_at.iso8601, uuid: uuid)
    end
  end
end
