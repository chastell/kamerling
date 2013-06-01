require_relative '../spec_helper'

module Kamerling describe Repo do
  Tune = Struct.new :genre, :uuid do
    class << self
      alias :from_h :[]
    end
    def initialize genre: raise, uuid: UUID.new
      super genre, uuid
    end
  end

  describe '#<<' do
    it 'passes the Hash version of an object to the source' do
      tune = Tune[genre: :chap_hop]
      mock(source = fake) << { genre: :chap_hop, uuid: anything }
      Repo.new(source, Tune) << tune
    end
  end

  describe '#[]' do
    it 'hydrates the object found in the repo' do
      uuid   = UUID.new
      source = { { uuid: uuid } => { genre: :chap_hop, uuid: uuid } }
      Repo.new(source, Tune)[uuid].must_equal Tune[genre: :chap_hop, uuid: uuid]
    end

    it 'raises NotFound if the object is not found in the repo' do
      -> { Repo.new({}, Tune)[UUID.new] }.must_raise Repo::NotFound
    end
  end
end end
