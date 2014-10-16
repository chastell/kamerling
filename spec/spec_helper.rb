require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'
require 'bogus/minitest/spec'
require 'rack/test'
require 'kamerling'

Bogus.configure { |config| config.search_modules << Kamerling }

module Minitest
  class Spec
    include Rack::Test::Methods

    module DSL
      def fakes(*args)
        args.map { |arg| fake(arg) }
      end
    end
  end
end

def run_all_threads
  Thread.list.each(&:run)
end
