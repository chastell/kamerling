require_relative '../spec_helper'

module Kamerling describe Scribe do
  describe '#decipher' do
    it 'raises on undecipherable inputs' do
      -> { Scribe.new.decipher 'MESS age' }.must_raise Scribe::UnknownInput
    end

    it 'deciphers known inputs' do
      Scribe.new.decipher('RGST').must_equal Messages::RGST.new 'RGST'
    end
  end
end end
