module Kamerling class Franchus
  UnknownMessage = Class.new RuntimeError

  def handle string
    send "handle_#{string[0..3]}", string
  rescue NoMethodError
    raise UnknownMessage, string
  end
end end
