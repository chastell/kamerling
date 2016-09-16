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

    def <<(_object)
      raise NotImplementedError
    end

    def all
      projects = project_repo.all.group_by(&:id)
      table.all.map do |hash|
        klass.new(hash.merge(project: projects[hash[:project_id]].first))
      end
    end

    def fetch(id)
      case
      when hash = table[id: id]
        klass.new(hash.merge(project: project_repo.fetch(hash[:project_id])))
      when block_given?
        yield
      else
        raise NotFound
      end
    end

    def for_project(project)
      table.where(project_id: project.id).all.map(&Task.method(:new))
    end

    def mark_done(id:)
      table.where(id: id).update(done: true)
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
