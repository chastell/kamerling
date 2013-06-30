require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'bogus/minitest/spec'
require 'kamerling'

Bogus.configure { |config| config.search_modules << Kamerling }

module MiniTest::Spec::DSL
  def fakes *args
    args.map { |arg| fake arg }
  end
end
