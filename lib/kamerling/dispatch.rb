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
  end
end
