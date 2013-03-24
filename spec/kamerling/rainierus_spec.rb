require_relative '../spec_helper'

module Kamerling describe Rainierus do
  describe '#decipher' do
    it 'raises on undecipherable messages' do
      rainierus = Rainierus.new
      -> { rainierus.decipher 'MESS age' }.must_raise UnknownMessage
    end

    it 'deciphers known messages' do
      Rainierus.new.decipher('RGST').must_equal Messages::RGST.new 'RGST'
    end
  end
end end
