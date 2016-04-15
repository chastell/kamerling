# frozen_string_literal: true

require_relative 'addr'
require_relative 'client'
require_relative 'entity'
require_relative 'project'
require_relative 'task'

module Kamerling
  class Dispatch < Entity
    attrs addr: Addr, client: Client, dispatched_at: Time, project: Project,
          task: Task
    defaults dispatched_at: -> (*) { Time.now }

    def to_h
      addr.to_h.merge(client_uuid: client.uuid,
                      dispatched_at: dispatched_at.iso8601,
                      project_uuid: project.uuid, task_uuid: task.uuid,
                      uuid: uuid)
    end
  end
end
