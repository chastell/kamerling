require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'bogus/minitest'
require 'kamerling'

Bogus.configure { |config| config.search_modules << Kamerling }

module MiniTest::Spec::DSL
  def fakes *args
    args.map { |arg| fake arg }
  end
end

def spec_db
  @spec_db ||= Sequel.sqlite
end

Sequel.extension :migration
Sequel::Migrator.run spec_db, 'lib/kamerling/migrations'
