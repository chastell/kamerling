require_relative '../spec_helper'

module Kamerling describe Project do
  describe '.new' do
    it 'gives the project a random UUID if not provided' do
      p1 = Project[name: 'a']
      p2 = Project[name: 'b']
      p1.uuid.wont_equal p2.uuid
    end
  end
end end
