require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'bogus/minitest'
require 'kamerling'

Bogus.configure { |config| config.search_modules << Kamerling }
