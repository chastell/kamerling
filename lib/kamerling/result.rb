# frozen_string_literal: true

require_relative 'addr'
require_relative 'client'
require_relative 'entity'
require_relative 'task'

module Kamerling
  class Result < Entity
    vals addr: Addr, client: Client, data: String, received_at: Time, task: Task
    defaults received_at: -> (*) { Time.now.utc }
  end
end
