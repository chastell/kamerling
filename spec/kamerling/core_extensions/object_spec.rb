require_relative '../../spec_helper'

module Kamerling describe CoreExtensions::Object do
  describe '#req' do
    it 'raises a RuntimeError that a parameter is required' do
      -> { CoreExtensions::Object.req(:foo) }.must_raise(RuntimeError)
        .message.must_include 'param foo is required'
    end
  end

  describe '#warn_off' do
    it 'turns $VERBOSE off inside the block' do
      assert $VERBOSE
      CoreExtensions::Object.warn_off { refute $VERBOSE }
      assert $VERBOSE
    end
  end
end end
