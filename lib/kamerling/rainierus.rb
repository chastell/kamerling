module Kamerling class Rainierus
  UnknownMessage = Class.new RuntimeError

  def decipher input
    Messages.const_get(input[0..3]).new
  rescue NameError
    raise UnknownMessage, input
  end
end end
