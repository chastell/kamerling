require_relative '../spec_helper'

module Kamerling describe Repos do
  describe '.<<' do
    it 'shuffles the object into the right repo' do
      Repos.repos = { Object => repo = fake(:repo) }
      Repos.<< object = Object.new
      repo.must_have_received :<<, [object]
    end

    it 'can be chained' do
      str_repo, sym_repo = fake(:repo), fake(:repo)
      Repos.repos = { String => str_repo, Symbol => sym_repo }
      Repos << 'str' << :sym
      str_repo.must_have_received :<<, ['str']
      sym_repo.must_have_received :<<, [:sym]
    end
  end

  describe '.[]' do
    it 'allows querying for repository objects' do
      client = fake :client, uuid: UUID.new
      Repos.repos = { Client => {} }
      Repos[Client][client.uuid].must_be_nil
      Repos.repos = { Client => { client.uuid => client } }
      Repos[Client][client.uuid].must_equal client
    end
  end

  describe '.clients' do
    it 'returns all clients' do
      Repos.repos = { Client => fake(:repo, all: all_clients = fake) }
      Repos.clients.must_equal all_clients
    end
  end

  describe '.clients_for' do
    it 'returns all clients for the given project' do
      clients  = [fake(:client), fake(:client)]
      project  = fake :project
      regs     = clients.map { |client| fake :registration, client: client }
      reg_repo = fake :repo
      stub(reg_repo).related_to(project) { regs }
      Repos.repos = { Registration => reg_repo }
      Repos.clients_for(project).must_equal clients
    end
  end

  describe '.db=' do
    it 'auto-migrates the passed db' do
      db = Sequel.sqlite
      warn_off { db.tables.wont_include :schema_info }
      Repos.db = db
      warn_off { db.tables.must_include :schema_info }
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

  describe '.project' do
    it 'returns the project with the given UUID' do
      gimps = fake :project, uuid: UUID.new
      Repos.repos = { Project => { gimps.uuid => gimps } }
      Repos.project(gimps.uuid).must_equal gimps
    end
  end

  describe '.projects' do
    it 'returns all projects' do
      Repos.repos = { Project => fake(:repo, all: all_projects = fake) }
      Repos.projects.must_equal all_projects
    end
  end

  describe '.tasks_for' do
    it 'returns all tasks for the given project' do
      project   = fake :project
      tasks     = [fake(:task), fake(:task)]
      task_repo = fake :repo
      stub(task_repo).related_to(project) { tasks }
      Repos.repos = { Task => task_repo }
      Repos.tasks_for(project).must_equal tasks
    end
  end

  describe 'when working on actual database' do
    before { Repos.db = Sequel.sqlite }

    it 'makes sure objects can be stored and retrieved' do
      addr    = Addr['127.0.0.1', 1981, :TCP]
      client  = Client.new addr: addr, uuid: UUID.new
      project = Project.new name: 'project name', uuid: UUID.new
      task    = Task.new data: 'data', project: project, uuid: UUID.new
      reg     = Registration.new addr: addr, client: client, project: project
      res     = Result.new addr: addr, client: client, data: 'da', task: task
      Repos << client << project << task << reg << res
      Repos[Client][client.uuid].must_equal client
      Repos[Project][project.uuid].must_equal project
      Repos[Registration][reg.uuid].must_equal reg
      Repos[Result][res.uuid].must_equal res
      Repos[Task][task.uuid].must_equal task
    end

    it 'makes sure objects can be updated' do
      client = Client.new addr: Addr['127.0.0.1', 1979, :TCP], uuid: UUID.new
      Repos << client
      client.addr.port = 1981
      Repos << client
      Repos[Client][client.uuid].addr.port.must_equal 1981
    end
  end
end end
