require_relative 'addr'
require_relative 'client'
require_relative 'project'
require_relative 'uuid_entity'

module Kamerling class Registration < UUIDEntity
  attrs addr: Addr, client: Client, project: Project
end end
