require_relative '../spec_helper'

module Kamerling describe RandomUUID do
  describe '.random_uuid' do
    it 'generates a random binary UUID' do
      RandomUUID.random_uuid.size.must_equal 16
      RandomUUID.random_uuid.wont_equal RandomUUID.random_uuid
    end
  end
end end
