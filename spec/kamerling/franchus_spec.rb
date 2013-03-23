require_relative '../spec_helper'

module Kamerling describe Franchus do
  describe '#handle' do
    it 'raises on unknown messages' do
      -> { Franchus.new.handle 'MESS age' }.must_raise Franchus::UnknownMessage
    end

    it 'handles known messages' do
      franchus = Franchus.new
      def franchus.handle_MESS(msg); msg[5..-1]; end
      franchus.handle('MESS age').must_equal 'age'
    end
  end
end end
