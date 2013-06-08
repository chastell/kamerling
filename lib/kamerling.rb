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

require_relative 'kamerling/addr'
require_relative 'kamerling/handler'
require_relative 'kamerling/message'
require_relative 'kamerling/messages'
require_relative 'kamerling/receiver'
require_relative 'kamerling/registrar'
require_relative 'kamerling/repo'
require_relative 'kamerling/repos'
require_relative 'kamerling/server'
require_relative 'kamerling/task_dispatcher'
require_relative 'kamerling/uuid'
require_relative 'kamerling/uuid_object'
require_relative 'kamerling/client'
require_relative 'kamerling/project'
require_relative 'kamerling/registration'
require_relative 'kamerling/result'
require_relative 'kamerling/task'
