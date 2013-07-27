module Kamerling module CoreExtensions module Object
  module_function

  def req param
    method   = caller.first[/`(.*)'$/, 1]
    callsite = Class === self ? "#{name}.#{method}" : "#{self.class}##{method}"
    raise "#{callsite}: param #{param} is required"
  end

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
