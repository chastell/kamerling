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
      @repos ||= {
        Client       => Repo.new(db[:clients],       Client),
        Project      => Repo.new(db[:projects],      Project),
        Registration => Repo.new(db[:registrations], Registration),
        Result       => Repo.new(db[:results],       Result),
        Task         => Repo.new(db[:tasks],         Task),
      }
    end
  end
end end
