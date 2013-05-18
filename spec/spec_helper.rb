require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'bogus/minitest'
require 'kamerling'

Bogus.configure { |config| config.search_modules << Kamerling }

module MiniTest::Spec::DSL
  def fakes *args
    args.each { |arg| fake arg }
  end
end

def spec_repos
  @spec_repos ||= Sequel.sqlite
end

Sequel.extension :migration
Sequel::Migrator.run spec_repos, 'lib/kamerling/migrations'
