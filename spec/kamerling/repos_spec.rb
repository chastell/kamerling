require_relative '../spec_helper'

module Kamerling describe Repos do
  describe '.<<' do
    it 'shuffles the object into the right repo' do
      Repos.repos = { Object => repo = fake(:repo) }
      Repos.<< object = Object.new
      repo.must_have_received :<<, [object]
    end

    it 'can be chained' do
      Repos.repos = { String => str = fake(:repo), Symbol => sym = fake(:repo) }
      Repos << 'str' << :sym
      str.must_have_received :<<, ['str']
      sym.must_have_received :<<, [:sym]
    end
  end

  describe '.[]' do
    it 'allows querying for repository objects' do
      client = fake :client
      Repos.repos = { Client => {} }
      Repos[Client][client.uuid].must_be_nil
      Repos.repos = { Client => { client.uuid => client } }
      Repos[Client][client.uuid].must_equal client
    end
  end

  describe '.db=' do
    it 'auto-migrates the passed db' do
      db = Sequel.sqlite
      $VERBOSE = false
      db.tables.wont_include :schema_info
      $VERBOSE = true
      Repos.db = db
      $VERBOSE = false
      db.tables.must_include :schema_info
      $VERBOSE = true
    end
  end

  describe '.free_clients_for' do
    it 'returns free clients for the given project' do
      busy_client = fake :client, busy: true
      free_client = fake :client, busy: false
      busy_reg    = fake :registration, client: busy_client
      free_reg    = fake :registration, client: free_client
      project     = fake :project
      repo        = fake :repo
      stub(repo).related_to(project) { [busy_reg, free_reg] }
      Repos.repos = { Registration => repo }
      Repos.free_clients_for(project).must_equal [free_client]
    end
  end

  describe '.next_task_for' do
    it 'returns the next task for the given project' do
      project   = fake :project
      done_task = fake :task, done: true
      new_task  = fake :task, done: false
      repo      = fake :repo
      stub(repo).related_to(project) { [done_task, new_task] }
      Repos.repos = { Task => repo }
      Repos.next_task_for(project).must_equal new_task
    end
  end

  describe '.projects' do
    it 'returns all projects' do
      Repos.repos = { Project => fake(:repo, all: all_projects = fake) }
      Repos.projects.must_equal all_projects
    end
  end

  describe 'when working on actual database' do
    before { Repos.db = Sequel.sqlite }

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

    it 'makes sure objects can be updated' do
      Repos << client = Client[addr: Addr['127.0.0.1', 1979], uuid: UUID.new]
      client.addr.port = 1981
      Repos << client
      Repos[Client][client.uuid].addr.port.must_equal 1981
    end
  end
end end
