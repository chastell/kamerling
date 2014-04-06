module Kamerling class Registration < UUIDEntity
  attrs addr: Addr, client: Client, project: Project
end end
