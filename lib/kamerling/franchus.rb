module Kamerling class Franchus
  Messages       = []
  UnknownMessage = Class.new RuntimeError

  def handle message
    raise UnknownMessage unless Messages.include? message[0..3]
  end
end end
