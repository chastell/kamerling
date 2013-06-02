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
      mock(source = fake) << { genre: :chap_hop, uuid: tune.uuid }
      Repo.new(Tune, source) << tune
    end

    it 'updates the source’s version if it exists there' do
      dataset = fake
      source  = fake
      tune    = Tune[genre: :chap_hop]
      stub(source).<<(tune.to_h) { raise Sequel::UniqueConstraintViolation }
      stub(source).where(uuid: tune.uuid) { dataset }
      Repo.new(Tune, source) << tune
      dataset.must_have_received :update, [tune.to_h]
    end
  end

  describe '#[]' do
    it 'hydrates the object found in the repo' do
      uuid   = UUID.new
      source = { { uuid: uuid } => { genre: :chap_hop, uuid: uuid } }
      Repo.new(Tune, source)[uuid].must_equal Tune[genre: :chap_hop, uuid: uuid]
    end

    it 'raises NotFound if the object is not found in the repo' do
      -> { Repo.new(Tune, {})[UUID.new] }.must_raise Repo::NotFound
    end
  end

  describe '#all' do
    it 'returns all objects' do
      tune = Tune[genre: :chap_hop, uuid: UUID.new]
      source = fake all: [{ genre: :chap_hop, uuid: tune.uuid }]
      Repo.new(Tune, source).all.must_equal [tune]
    end
  end
end end
