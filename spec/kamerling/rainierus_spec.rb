require_relative '../spec_helper'

module Kamerling describe Rainierus do
  describe '#decipher' do
    it 'raises on undecipherable messages' do
      rainierus = Rainierus.new
      -> { rainierus.decipher 'MESS age' }.must_raise Rainierus::UnknownMessage
    end
  end
end end
