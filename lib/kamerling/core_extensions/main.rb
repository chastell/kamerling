module Kamerling
  module CoreExtensions
    module Main
      module_function

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
