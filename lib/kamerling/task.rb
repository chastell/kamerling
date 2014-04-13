require_relative 'project'
require_relative 'uuid_entity'

module Kamerling class Task < UUIDEntity
  attrs data: String, done: Boolean, project: Project
  defaults done: false
end end
