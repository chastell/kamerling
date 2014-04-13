require_relative 'addr'
require_relative 'client'
require_relative 'task'
require_relative 'uuid_entity'

module Kamerling class Result < UUIDEntity
  attrs addr: Addr, client: Client, data: String, task: Task
end end
