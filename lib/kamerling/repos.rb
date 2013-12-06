warn_off { require 'sequel' }

Sequel.extension :migration

module Kamerling class Repos
  class << self
    attr_writer :repos

    def << object
      repos[object.class] << object
      self
    end

    def [] klass
      repos[klass]
    end

    def clients
      repos[Client].all
    end

    def clients_for project
      repos[Registration].related_to(project).map(&:client)
    end

    def db= db
      warn_off { Sequel::Migrator.run db, "#{__dir__}/migrations" }
      @repos = nil
      @db    = db
    end

    def free_clients_for project
      repos[Registration].related_to(project).map(&:client).reject(&:busy)
    end

    def next_task_for project
      repos[Task].related_to(project).reject(&:done).first
    end

    def projects
      repos[Project].all
    end

    def tasks_for project_uuid: req(:project_uuid)
      repos[Task].related_to repos[Project][project_uuid]
    end

    private

    def db
      @db ||= self.db = Sequel.sqlite
    end

    def repos
      @repos ||= Hash.new do |repos, klass|
        table = "#{klass.name.split('::').last.downcase}s".to_sym
        repos[klass] = Repo.new klass, warn_off { db[table] }
      end
    end
  end
end end
