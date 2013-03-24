module Kamerling class Rainierus
  def decipher input
    Messages.const_get(input[0..3]).new input
  rescue NameError
    raise UnknownMessage, input
  end
end end
