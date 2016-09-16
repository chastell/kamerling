# frozen_string_literal: true

require_relative 'entity'
require_relative 'project'

module Kamerling
  class Task < Entity
    vals data: String, done: Boolean
    defaults done: false
  end
end
