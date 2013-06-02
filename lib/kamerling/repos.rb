verbose = $VERBOSE; $VERBOSE = false; require 'sequel'; $VERBOSE = verbose

Sequel.extension :migration

module Kamerling class Repos
  class << self
    attr_writer :repos

    def << object
      repos[object.class] << object
    end

    def [] klass
      repos[klass]
    end

    def db= db
      Sequel::Migrator.run db, "#{__dir__}/migrations"
      @repos = nil
      @db    = db
    end

    def free_clients_for project
      repos[Registration].related_to(project).map(&:client).reject(&:busy)
    end

    def projects
      repos[Project].all
    end

    private

    def db
      @db ||= self.db = Sequel.sqlite
    end

    def repos
      @repos ||= Hash.new do |repos, klass|
        table = "#{klass.name.split('::').last.downcase}s".to_sym
        repos[klass] = Repo.new klass, db[table]
      end
    end
  end
end end
