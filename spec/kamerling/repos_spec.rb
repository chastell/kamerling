require_relative '../spec_helper'

module Kamerling describe Repos do
  before { Repos.db = Sequel.sqlite }

  describe '.<<' do
    it 'shuffles the object into the right repo' do
      repo = fake :repo
      Repos.<< object = Object.new, repos: { Object => repo }
      repo.must_have_received :<<, [object]
    end
  end

  describe '.[]' do
    it 'allows querying for repository objects' do
      clnt = fake :client
      Repos[Client, repo: {}][clnt.uuid].must_be_nil
      Repos[Client, repo: { clnt.uuid => clnt }][clnt.uuid].must_equal clnt
    end
  end

  describe '.db=' do
    it 'auto-migrates the passed db' do
      db = Sequel.sqlite
      db.tables.wont_include :schema_info
      Repos.db = db
      db.tables.must_include :schema_info
    end

    it 'makes sure objects can be stored and retrieved' do
      addr = Addr['127.0.0.1', 1981]
      Repos << client  = Client[addr: addr, uuid: UUID.new]
      Repos << project = Project[name: 'project name', uuid: UUID.new]
      Repos << task    = Task[input: 'input', project: project, uuid: UUID.new]
      Repos << reg = Registration[addr: addr, client: client, project: project]
      Repos << res = Result[addr: addr, client: client, data: 'da', task: task]
      Repos[Client][client.uuid].must_equal client
      Repos[Project][project.uuid].must_equal project
      Repos[Registration][reg.uuid].must_equal reg
      Repos[Result][res.uuid].must_equal res
      Repos[Task][task.uuid].must_equal task
    end
  end
end end
