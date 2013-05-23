require_relative '../spec_helper'

module Kamerling describe Repos do
  describe '.configure' do
    it 'auto-migrates the provided Sequel database' do
      sequel_db = Sequel.sqlite
      sequel_db.tables.wont_include :schema_info
      Repos.configure sequel_db: sequel_db
      sequel_db.tables.must_include :schema_info
    end
  end
end end
