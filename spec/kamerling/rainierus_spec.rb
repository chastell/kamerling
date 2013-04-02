require_relative '../spec_helper'

module Kamerling describe Rainierus do
  describe '#decipher' do
    it 'raises on undecipherable inputs' do
      rainierus = Rainierus.new
      -> { rainierus.decipher 'MESS age' }.must_raise Rainierus::UnknownInput
    end

    it 'deciphers known inputs' do
      Rainierus.new.decipher('RGST').must_equal Messages::RGST.new 'RGST'
    end
  end
end end
