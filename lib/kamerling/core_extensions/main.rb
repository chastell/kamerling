module Kamerling
  module CoreExtensions
    module Main
      module_function

      def req param
        meth     = caller.first[/`(.*)'$/, 1]
        callsite = is_a?(Class) ? "#{name}.#{meth}" : "#{self.class}##{meth}"
        fail "#{callsite}: param #{param} is required"
      end

      def warn_off
        verbose  = $VERBOSE
        $VERBOSE = false
        yield
      ensure
        $VERBOSE = verbose
      end
    end
  end
end

include Kamerling::CoreExtensions::Main
