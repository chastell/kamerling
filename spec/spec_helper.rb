require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'bogus'
require 'ostruct'
require 'kamerling'

include Bogus::MockingDSL

def repos
  @repos ||= Sequel.sqlite
end

Sequel.extension :migration
Sequel::Migrator.run repos, 'lib/kamerling/migrations'
