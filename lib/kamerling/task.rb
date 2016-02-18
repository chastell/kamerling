# frozen_string_literal: true

require_relative 'entity'
require_relative 'project'

module Kamerling
  class Task < Entity
    attrs data: String, done: Boolean, project: Project
    defaults done: false

    def new_to_h
      to_h.reject { |key, _| key == :project }.merge(project_uuid: project.uuid)
    end
  end
end
