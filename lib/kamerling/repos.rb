verbose = $VERBOSE; $VERBOSE = false; require 'sequel'; $VERBOSE = verbose

Sequel.extension :migration

module Kamerling class Repos
  class << self
    def << object, repos: repos
      repos[object.class] << object
    end

    def [] klass, repo: repos[klass]
      repo
    end

    def db= db
      Sequel::Migrator.run db, "#{__dir__}/migrations"
      @repos = nil
      @db    = db
    end

    private

    def db
      @db ||= self.db = Sequel.sqlite
    end

    def repos
      @repos ||= Hash.new do |repos, klass|
        table = "#{klass.name.split('::').last.downcase}s".to_sym
        repos[klass] = Repo.new db[table], klass
      end
    end
  end
end end
