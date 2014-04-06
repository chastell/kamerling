module Kamerling class Result < UUIDEntity
  attrs addr: Addr, client: Client, data: String, task: Task
end end
