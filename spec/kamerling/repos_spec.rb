require_relative '../spec_helper'

module Kamerling describe Repos do
  before { Repos.db = Sequel.sqlite }
  let(:addr) { Addr['127.0.0.1', 1981] }

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
    let(:client)  { Client[addr: addr, uuid: UUID.new] }
    let(:project) { Project[name: 'project name', uuid: UUID.new] }
    let(:task)    { Task[input: 'input', project: project, uuid: UUID.new] }

    it 'auto-migrates the passed db' do
      db = Sequel.sqlite
      db.tables.wont_include :schema_info
      Repos.db = db
      db.tables.must_include :schema_info
    end

    it 'makes sure clients can be stored and retrieved' do
      Repos << client
      Repos[Client][client.uuid].must_equal client
    end

    it 'makes sure projects can be stored and retrieved' do
      Repos << project
      Repos[Project][project.uuid].must_equal project
    end

    it 'makes sure registrations can be stored and retrieved' do
      Repos << project
      Repos << client
      Repos << reg = Registration[addr: addr, client: client, project: project]
      Repos[Registration][reg.uuid].must_equal reg
    end

    it 'makes sure results can be stored and retrieved' do
      Repos << project
      Repos << client
      Repos << task
      Repos << res = Result[addr: addr, client: client, data: 'da', task: task]
      Repos[Result][res.uuid].must_equal res
    end

    it 'makes sure tasks can be stored and retrieved' do
      Repos << project
      Repos << task
      Repos[Task][task.uuid].must_equal task
    end
  end
end end
