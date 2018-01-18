require 'ruby_warning_filter'
$stderr = RubyWarningFilter.new($stderr)
ENV['MT_NO_EXPECTATIONS'] = 'true'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'
require 'bogus/minitest/spec'
require 'rack/test'
require 'kamerling'

Bogus.configure { |config| config.search_modules << Kamerling }

def run_all_threads
  Thread.list.each(&:run)
end
