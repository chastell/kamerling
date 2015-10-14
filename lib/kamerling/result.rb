require_relative 'addr'
require_relative 'client'
require_relative 'entity'
require_relative 'task'

module Kamerling
  class Result < Entity
    attrs addr: Addr, client: Client, data: String, received_at: Time,
          task: Task
    defaults received_at: -> (*) { Time.now }
  end
end
