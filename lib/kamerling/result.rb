module Kamerling class Result < UUIDEntity
  attribute :addr,   Addr
  attribute :client, Client
  attribute :data,   String
  attribute :task,   Task
end end
