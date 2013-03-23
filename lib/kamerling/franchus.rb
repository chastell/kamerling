module Kamerling class Franchus
  UnknownMessage = Class.new RuntimeError

  def handle input, scribe: nil
    message = scribe.decipher input
    send "handle_#{message.type}", message
  rescue NoMethodError
    raise UnknownMessage, input
  end
end end
