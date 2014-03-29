require_relative '../spec_helper'

module Kamerling describe Repo do
  Tune = Class.new(UUIDEntity) { attribute :genre, Symbol }

  describe '#<<' do
    it 'passes the Hash version of an object to the source via a mapper' do
      tune   = Tune.new genre: :chap_hop
      mapper = fake :mapper, as: :class, to_h: tune.to_h
      source = fake Sequel::Dataset
      Repo.new(Tune, source, mapper: mapper) << tune
      source.must_have_received :<<, [tune.to_h]
    end

    it 'updates the source’s version if it exists there' do
      dataset = fake Sequel::Dataset
      source  = fake Sequel::Dataset
      tune    = Tune.new genre: :chap_hop
      stub(source).<<(tune.to_h) { fail Sequel::UniqueConstraintViolation }
      stub(source).where(uuid: tune.uuid) { dataset }
      Repo.new(Tune, source) << tune
      dataset.must_have_received :update, [tune.to_h]
    end
  end

  describe '#[]' do
    it 'hydrates the object found in the repo via a mapper' do
      tune   = Tune.new genre: :chap_hop
      source = { { uuid: tune.uuid } => { genre: :chap_hop, uuid: tune.uuid } }
      mapper = fake :mapper, as: :class, from_h: tune
      Repo.new(Tune, source, mapper: mapper)[tune.uuid].must_equal tune
    end

    it 'raises NotFound if the object is not found in the repo' do
      -> { Repo.new(Tune, {})[UUID.new] }.must_raise Repo::NotFound
    end
  end

  describe '#all' do
    it 'returns all objects via a mapper' do
      tune = Tune.new genre: :chap_hop
      source = fake Sequel::Dataset,
                    all: [{ genre: :chap_hop, uuid: tune.uuid }]
      mapper = fake :mapper, as: :class, from_h: tune
      Repo.new(Tune, source, mapper: mapper).all.must_equal [tune]
    end
  end

  describe '#related_to' do
    it 'returns objects related to the given object' do
      tunes   = [Tune.new(genre: :ragga), Tune.new(genre: :reggae)]
      project = fake :project, uuid: UUID.new
      results = [
        { genre: :ragga, uuid: tunes.first.uuid },
        { genre: :reggae, uuid: tunes.last.uuid },
      ]
      source = fake Sequel::Dataset
      stub(source).where(project_uuid: project.uuid) { results }
      Repo.new(Tune, source).related_to(project).must_equal tunes
    end
  end
end end
