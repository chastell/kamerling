module Kamerling class Rainierus
  MessageTypes   = []
  UnknownMessage = Class.new RuntimeError

  def decipher input
    raise UnknownMessage, input unless MessageTypes.include? input[0..3]
  end
end end
