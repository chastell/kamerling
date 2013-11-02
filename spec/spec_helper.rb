require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'bogus/minitest/spec'
require 'rack/test'
require 'kamerling'

Bogus.configure { |config| config.search_modules << Kamerling }

module MiniTest::Spec::DSL
  def fakes *args
    args.map { |arg| fake arg }
  end
end

class MiniTest::Spec
  include Rack::Test::Methods
end

Thread.abort_on_exception = true

def run_all_threads
  Thread.list.each { |thread| thread.run if thread.alive? }
end
