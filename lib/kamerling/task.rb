module Kamerling class Task < UUIDEntity
  attrs data: String, done: Boolean, project: Project
  defaults done: false
end end
