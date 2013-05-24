require_relative '../spec_helper'

module Kamerling describe Repos do
  describe '.[]' do
    it 'allows querying for repository objects' do
      uuid   = '16B client  UUID'
      client = Client[uuid: uuid]
      Repos[Client, repo: {}][uuid].must_be_nil
      Repos[Client, repo: { uuid => client }][uuid].must_equal client
    end
  end

  describe '.db=' do
    it 'allows passing a Sequel db and auto-migrates it' do
      db = Sequel.sqlite
      db.tables.wont_include :schema_info
      Repos.db = db
      db.tables.must_include :schema_info
    end
  end
end end
