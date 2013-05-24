$VERBOSE = false
require 'sequel'
$VERBOSE = true

Sequel.extension :migration

module Kamerling class Repos
  def self.db= db
    Sequel::Migrator.run db, "#{__dir__}/migrations"
  end
end end
