$VERBOSE = false
require 'sequel'
$VERBOSE = true

Sequel.extension :migration

module Kamerling class Repos
  class << self
    def [] klass, repo: raise
      repo
    end

    def db= db
      Sequel::Migrator.run db, "#{__dir__}/migrations"
    end
  end
end end
