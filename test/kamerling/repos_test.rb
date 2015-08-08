require 'sequel'
require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/registration'
require_relative '../../lib/kamerling/repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/result'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/uuid'

module Kamerling                          # rubocop:disable Metrics/ModuleLength
  describe Repos do
    describe '.<<' do
      it 'shuffles the object into the right repo' do
        Repos.repos = { Object => repo = fake(:repo) }
        Repos.<< object = Object.new
        _(repo).must_have_received :<<, [object]
      end

      it 'can be chained' do
        str_repo = fake(:repo)
        sym_repo = fake(:repo)
        Repos.repos = { String => str_repo, Symbol => sym_repo }
        Repos << 'str' << :sym
        _(str_repo).must_have_received :<<, ['str']
        _(sym_repo).must_have_received :<<, [:sym]
      end
    end

    describe '.[]' do
      it 'allows querying for repository objects' do
        client = Client.new
        Repos.repos = { Client => {} }
        _(Repos[Client][client.uuid]).must_be_nil
        Repos.repos = { Client => { client.uuid => client } }
        _(Repos[Client][client.uuid]).must_equal client
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
        clients  = [Client.new, Client.new]
        project  = Project.new
        regs     = clients.map { |client| Registration.new(client: client) }
        reg_repo = fake(:repo)
        stub(reg_repo).related_to(project) { regs }
        Repos.repos = { Registration => reg_repo }
        _(Repos.clients_for(project)).must_equal clients
      end
    end

    describe '.db=' do
      it 'auto-migrates the passed db' do
        db = Sequel.sqlite
        warn_off { _(db.tables).wont_include :schema_info }
        Repos.db = db
        warn_off { _(db.tables).must_include :schema_info }
      end
    end

    describe '.free_clients_for' do
      it 'returns free clients for the given project' do
        busy_client = Client.new(busy: true)
        free_client = Client.new(busy: false)
        busy_reg    = Registration.new(client: busy_client)
        free_reg    = Registration.new(client: free_client)
        project     = Project.new
        repo        = fake(:repo)
        stub(repo).related_to(project) { [busy_reg, free_reg] }
        Repos.repos = { Registration => repo }
        _(Repos.free_clients_for(project)).must_equal [free_client]
      end
    end

    describe '.next_task_for' do
      it 'returns the next task for the given project' do
        project   = Project.new
        done_task = Task.new(done: true)
        new_task  = Task.new(done: false)
        repo      = fake(:repo)
        stub(repo).related_to(project) { [done_task, new_task] }
        Repos.repos = { Task => repo }
        _(Repos.next_task_for(project)).must_equal new_task
      end
    end

    describe '.project' do
      it 'returns the project with the given UUID' do
        gimps = Project.new
        Repos.repos = { Project => { gimps.uuid => gimps } }
        _(Repos.project(gimps.uuid)).must_equal gimps
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
        project   = Project.new
        tasks     = [Task.new, Task.new]
        task_repo = fake(:repo)
        stub(task_repo).related_to(project) { tasks }
        Repos.repos = { Task => task_repo }
        _(Repos.tasks_for(project)).must_equal tasks
      end
    end

    describe 'when working on actual database' do
      before { Repos.db = Sequel.sqlite }

      it 'makes sure objects can be stored and retrieved' do
        addr    = Addr['127.0.0.1', 1981, :TCP]
        client  = Client.new(addr: addr)
        project = Project.new(name: 'project name', uuid: UUID.new)
        task    = Task.new(data: 'data', project: project, uuid: UUID.new)
        reg     = Registration.new(addr: addr, client: client, project: project)
        res     = Result.new(addr: addr, client: client, data: 'da', task: task)
        Repos << client << project << task << reg << res
        _(Repos[Client][client.uuid]).must_equal client
        _(Repos[Project][project.uuid]).must_equal project
        _(Repos[Registration][reg.uuid]).must_equal reg
        _(Repos[Result][res.uuid]).must_equal res
        _(Repos[Task][task.uuid]).must_equal task
      end

      it 'makes sure objects can be updated' do
        client = Client.new(addr: Addr['127.0.0.1', 1979, :TCP])
        Repos << client
        client.busy = true
        Repos << client
        assert Repos[Client][client.uuid].busy
      end
    end
  end
end
