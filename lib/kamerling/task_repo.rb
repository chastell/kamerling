# frozen_string_literal: true

require_relative 'new_repo'
require_relative 'task'

module Kamerling
  class TaskRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @klass = Task
      @table = db[:tasks]
    end

    def for_project(project_uuid)
      table.where(project_uuid: project_uuid).all.map(&Task.method(:new))
    end

    def next_for_project(project_uuid)
      case
      when hash = table[done: false, project_uuid: project_uuid]
        Task.new(hash)
      else
        raise NotFound
      end
    end
  end
end
