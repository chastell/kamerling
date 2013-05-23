module Kamerling class Repos
  def self.configure sequel_db: nil
    Sequel.extension :migration
    Sequel::Migrator.run sequel_db, "#{__dir__}/migrations"
  end
end end
