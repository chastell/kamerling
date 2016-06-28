# frozen_string_literal: true

require_relative 'repo'
require_relative 'task'

module Kamerling
  class TaskRepo < Repo
    def for_project(project)
      table.where(project_id: project.id).all.map(&Task.method(:new))
    end

    def next_for_project(project)
      case
      when hash = table[done: false, project_id: project.id]
        Task.new(hash)
      else
        raise NotFound
      end
    end

    private

    def klass
      Task
    end

    def table
      db[:tasks]
    end
  end
end
