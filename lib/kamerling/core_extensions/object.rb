module Kamerling module CoreExtensions module Object
  def warn_off
    verbose  = $VERBOSE
    $VERBOSE = false
    yield
  ensure
    $VERBOSE = verbose
  end
end end end

class Object
  include Kamerling::CoreExtensions::Object
end
