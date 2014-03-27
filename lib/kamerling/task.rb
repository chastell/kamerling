module Kamerling class Task < UUIDEntity
  attribute :data,    String
  attribute :done,    Boolean, default: false
  attribute :project, Project
end end
