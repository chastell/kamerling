require_relative 'kamerling/core_extensions/main'

warn_off { require 'private_attr' }

Class.include PrivateAttr

require_relative 'kamerling/core_extensions/main'
require_relative 'kamerling/logging'
require_relative 'kamerling/server_runner'
