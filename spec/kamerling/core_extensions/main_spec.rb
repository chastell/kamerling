require_relative '../../spec_helper'

module Kamerling describe CoreExtensions::Main do
  describe '#warn_off' do
    it 'turns $VERBOSE off inside the block' do
      assert $VERBOSE
      CoreExtensions::Main.warn_off { refute $VERBOSE }
      assert $VERBOSE
    end
  end
end end
