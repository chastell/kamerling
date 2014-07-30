require_relative 'addr'
require_relative 'client'
require_relative 'project'
require_relative 'task'
require_relative 'uuid_entity'

module Kamerling
  class Dispatch < UUIDEntity
    attrs addr: Addr, client: Client, dispatched_at: Time, project: Project,
          task: Task
    defaults dispatched_at: -> * { Time.now }
  end
end
