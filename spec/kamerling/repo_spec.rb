require_relative '../spec_helper'

module Kamerling describe Repo do
  describe '#<<' do
    it 'passes the Hash version of an object to the source' do
      object = Struct.new(:key).new :value
      mock(source = fake) << { key: :value }
      Repo.new(source) << object
    end
  end
end end
