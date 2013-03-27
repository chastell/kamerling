require_relative 'kamerling/franchus'
require_relative 'kamerling/jordan'
require_relative 'kamerling/message'
require_relative 'kamerling/messages'
require_relative 'kamerling/rainierus'

module Kamerling
  UnknownMessage = Class.new RuntimeError
end
