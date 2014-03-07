module Kamerling module CoreExtensions module Main
  module_function

  def req param
    method   = caller.first[/`(.*)'$/, 1]
    callsite = Class === self ? "#{name}.#{method}" : "#{self.class}##{method}"
    fail "#{callsite}: param #{param} is required"
  end

  def warn_off
    verbose  = $VERBOSE
    $VERBOSE = false
    yield
  ensure
    $VERBOSE = verbose
  end
end end end
