module Kamerling class Task < UUIDEntity
  attrs data: String, project: Project
  attribute :done, Boolean, default: false
end end
