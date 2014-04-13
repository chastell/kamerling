require_relative '../../spec_helper'
require_relative '../../../lib/kamerling/core_extensions/main'

module Kamerling describe CoreExtensions::Main do
  describe '#req' do
    it 'raises a RuntimeError that a parameter is required' do
      -> { CoreExtensions::Main.req(:foo) }.must_raise(RuntimeError)
        .message.must_include 'param foo is required'
    end
  end

  describe '#warn_off' do
    it 'turns $VERBOSE off inside the block' do
      assert $VERBOSE
      CoreExtensions::Main.warn_off { refute $VERBOSE }
      assert $VERBOSE
    end
  end
end end
