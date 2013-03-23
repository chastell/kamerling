module Kamerling class Franchus
  def handle input, scribe: Rainierus.new
    message = scribe.decipher input
    send "handle_#{message.type}", message
  rescue NoMethodError
    raise UnknownMessage, input
  end
end end
