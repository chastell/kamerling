# frozen_string_literal: true

require_relative 'entity'
require_relative 'project'

module Kamerling
  class Task < Entity
    attrs data: String, done: Boolean, project: Project
    defaults done: false
  end
end
