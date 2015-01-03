require_relative '../../test_helper'
require_relative '../../../lib/kamerling/core_extensions/main'

module Kamerling
  describe CoreExtensions::Main do
    describe '#warn_off' do
      before { @verbose = $VERBOSE }
      after  { $VERBOSE = @verbose }

      it 'when $VERBOSE is on it turns it off inside the block and back on' do
        $VERBOSE = true
        CoreExtensions::Main.warn_off { refute $VERBOSE }
        assert $VERBOSE
      end

      it 'when $VERBOSE is off it keeps it off' do
        $VERBOSE = false
        CoreExtensions::Main.warn_off { refute $VERBOSE }
        refute $VERBOSE
      end
    end
  end
end
