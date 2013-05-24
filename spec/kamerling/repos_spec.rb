require_relative '../spec_helper'

module Kamerling describe Repos do
  describe '.db=' do
    it 'allows passing a Sequel db and auto-migrates it' do
      db = Sequel.sqlite
      db.tables.wont_include :schema_info
      Repos.db = db
      db.tables.must_include :schema_info
    end
  end
end end
