require_relative '../spec_helper'

module Kamerling describe Repos do
  describe '.<<' do
    it 'shuffles the object into the right repo' do
      repo = fake :repo
      Repos.<< object = Object.new, repos: { Object => repo }
      repo.must_have_received :<<, [object]
    end
  end

  describe '.[]' do
    it 'allows querying for repository objects' do
      uuid   = '16B client  UUID'
      client = Client[addr: Addr['127.0.0.1', 1981], uuid: uuid]
      Repos[Client, repo: {}][uuid].must_be_nil
      Repos[Client, repo: { uuid => client }][uuid].must_equal client
    end
  end

  describe '.db=' do
    it 'auto-migrates the passed db' do
      db = Sequel.sqlite
      db.tables.wont_include :schema_info
      Repos.db = db
      db.tables.must_include :schema_info
    end

    it 'makes sure clients can be stored and retrieved' do
      client = Client[addr: Addr['127.0.0.1', 1981], uuid: '16B client  UUID']
      Repos << client
      Repos[Client]['16B client  UUID'].must_equal client
    end
  end
end end
