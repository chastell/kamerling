module Kamerling class Scribe
  UnknownInput = Class.new RuntimeError

  def decipher input
    Messages.const_get(input[0..3]).new input
  rescue NameError
    raise UnknownInput, input
  end
end end
