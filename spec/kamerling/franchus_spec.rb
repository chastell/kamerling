require_relative '../spec_helper'

module Kamerling describe Franchus do
  describe '#handle' do
    it 'raises on unknown messages' do
      -> { Franchus.new.handle 'MESS age' }.must_raise UnknownMessage
    end

    it 'handles known messages' do
      scribe   = double decipher: -> _ { double type: 'MESS' }
      franchus = Franchus.new
      def franchus.handle_MESS message
        message.type
      end
      franchus.handle('MESSage', scribe: scribe).must_equal 'MESS'
    end
  end
end end
