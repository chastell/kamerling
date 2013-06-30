require_relative '../spec_helper'

module Kamerling describe Repo do
  Tune = Kamerling.UUIDObject :genre

  describe '#<<' do
    it 'passes the Hash version of an object to the source' do
      tune = Tune.new genre: :chap_hop
      mock(source = fake) << { genre: :chap_hop, uuid: tune.uuid }
      Repo.new(Tune, source) << tune
    end

    it 'updates the source’s version if it exists there' do
      dataset = fake
      source  = fake
      tune    = Tune.new genre: :chap_hop
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
      Repo.new(Tune, source)[uuid]
        .must_equal Tune.new genre: :chap_hop, uuid: uuid
    end

    it 'raises NotFound if the object is not found in the repo' do
      -> { Repo.new(Tune, {})[UUID.new] }.must_raise Repo::NotFound
    end
  end

  describe '#all' do
    it 'returns all objects' do
      tune = Tune.new genre: :chap_hop, uuid: UUID.new
      source = fake all: [{ genre: :chap_hop, uuid: tune.uuid }]
      Repo.new(Tune, source).all.must_equal [tune]
    end
  end

  describe '#related_to' do
    it 'returns objects related to the given object' do
      tunes   = [Tune.new(genre: :ragga), Tune.new(genre: :reggae)]
      project = fake :project, uuid: UUID.new
      stub(source = fake).where(project_uuid: project.uuid) { [
        { genre: :ragga, uuid: tunes.first.uuid },
        { genre: :reggae, uuid: tunes.last.uuid },
      ] }
      Repo.new(Tune, source).related_to(project).must_equal tunes
    end
  end
end end
