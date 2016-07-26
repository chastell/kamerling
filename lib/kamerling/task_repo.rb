# frozen_string_literal: true

require 'sequel'
require_relative 'project_repo'
require_relative 'repo'
require_relative 'task'

module Kamerling
  class TaskRepo < Repo
    def initialize(db = Sequel.sqlite, project_repo: ProjectRepo.new(db))
      super(db)
      @project_repo = project_repo
    end

    def all
      projects = project_repo.all.group_by(&:id)
      table.all.map do |hash|
        klass.new(hash.merge(project: projects[hash[:project_id]].first))
      end
    end

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

    attr_reader :project_repo

    def klass
      Task
    end

    def table
      db[:tasks]
    end
  end
end
