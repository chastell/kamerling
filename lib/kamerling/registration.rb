require_relative 'addr'
require_relative 'client'
require_relative 'entity'
require_relative 'project'

module Kamerling
  class Registration < Entity
    attrs addr: Addr, client: Client, project: Project, registered_at: Time
    defaults registered_at: -> (*) { Time.now.utc }
  end
end
