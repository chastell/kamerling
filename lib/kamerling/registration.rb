module Kamerling class Registration < UUIDEntity
  attribute :addr,    Addr
  attribute :client,  Client
  attribute :project, Project
end end
