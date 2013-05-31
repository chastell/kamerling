require_relative '../spec_helper'

module Kamerling describe Repo do
  describe '#<<' do
    it 'passes the Hash version of an object to the source' do
      Pic = Struct.new :desc
      pic = Pic[:sunset]
      mock(source = fake) << { desc: :sunset }
      Repo.new(source, Pic) << pic
    end
  end

  describe '#[]' do
    it 'hydrates the object found in the repo' do
      Tune = Struct.new :genre do
        class << self
          alias :from_h :[]
        end
        def initialize genre: raise
          super genre
        end
      end
      uuid   = UUID.new
      source = { { uuid: uuid } => { genre: :chap_hop } }
      Repo.new(source, Tune)[uuid].must_equal Tune[genre: :chap_hop]
      Repo.new(source, Tune)[UUID.new].must_be_nil
    end
  end
end end
