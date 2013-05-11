require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'ostruct'
require 'kamerling'
require_relative './bogus_setup'

def repos
  @repos ||= Sequel.sqlite
end

Sequel.extension :migration
Sequel::Migrator.run repos, 'lib/kamerling/migrations'
