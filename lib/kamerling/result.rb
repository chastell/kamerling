# frozen_string_literal: true

require_relative 'addr'
require_relative 'client'
require_relative 'entity'
require_relative 'task'

module Kamerling
  class Result < Entity
    attrs addr: Addr, client: Client, data: String, received_at: Time,
          task: Task
    defaults received_at: -> (*) { Time.now.utc }

    def to_h
      addr.to_h.merge(client_uuid: client.uuid, data: data,
                      received_at: received_at.iso8601, task_uuid: task.uuid,
                      uuid: uuid)
    end
  end
end
