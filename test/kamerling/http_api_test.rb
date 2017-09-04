# frozen_string_literal: true

require 'nokogiri'
require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/http_api'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'
require_relative '../../lib/kamerling/task_dispatcher'
require_relative '../../lib/kamerling/tcp_addr'
require_relative '../../lib/kamerling/uuid'

module Kamerling
  describe HTTPAPI do
    include Rack::Test::Methods

    let(:client_repo)     { fake(ClientRepo)                     }
    let(:doc)             { Nokogiri::HTML(last_response.body)   }
    let(:ecc)             { Project.new                          }
    let(:gimps)           { Project.new                          }
    let(:project_repo)    { fake(ProjectRepo, all: [gimps, ecc]) }
    let(:task_dispatcher) { fake(TaskDispatcher)                 }
    let(:task_repo)       { fake(TaskRepo)                       }

    let(:app) { HTTPAPI.set(repos: repos, task_dispatcher: task_dispatcher) }

    let(:repos) do
      fake(Repos, client_repo: client_repo, project_repo: project_repo,
                  task_repo: task_repo)
    end

    describe 'GET /' do
      it 'contains links to clients and projects' do
        get '/'
        _(doc.at('#clients')['href']).must_equal '/clients'
        _(doc.at('#projects')['href']).must_equal '/projects'
      end
    end

    describe 'GET /clients' do
      it 'contains information on clients' do
        addr = TCPAddr['127.0.0.1', 1981]
        fpga = Client.new(addr: addr, busy: true, type: :FPGA)
        stub(client_repo).all { [fpga] }
        get '/clients'
        links = doc.css('#clients a[data-class=client]')
        _(links.first['data-addr']).must_equal 'tcp://127.0.0.1:1981'
        _(links.first['data-busy']).must_equal 'true'
        _(links.first['data-type']).must_equal 'FPGA'
        _(links.first['data-id']).must_equal fpga.id
        _(links.first['href']).must_equal "/clients/#{fpga.id}"
      end
    end

    describe 'GET /projects' do
      it 'contains links to and ids of projects' do
        get '/projects'
        links = doc.css('#projects a[data-class=project]')
        _(links.size).must_equal 2
        _(links.at("[data-id='#{gimps.id}']")['href'])
          .must_equal "/projects/#{gimps.id}"
      end
    end

    describe 'GET /projects/{id}' do
      let(:cpu) { Client.new(busy: false, type: :CPU) }
      let(:gpu) { Client.new(busy: true,  type: :GPU) }
      let(:three) { Task.new(done: false) }
      let(:seven) { Task.new(done: true)  }

      before do
        stub(client_repo).for_project(gimps) { [cpu, gpu] }
        stub(task_repo).for_project(gimps) { [three, seven] }
      end

      it 'contains links to and info on the project’s clients' do
        get "/projects/#{gimps.id}"
        links = doc.css('#clients a[data-class=client]')
        _(links.size).must_equal 2
        _(links.at("[data-id='#{cpu.id}']")['href'])
          .must_equal "/clients/#{cpu.id}"
        _(links.at("[data-id='#{cpu.id}']")['data-busy']).must_equal 'false'
        _(links.at("[data-id='#{gpu.id}']")['data-busy']).must_equal 'true'
        _(links.at("[data-id='#{cpu.id}']")['data-type']).must_equal 'CPU'
        _(links.at("[data-id='#{gpu.id}']")['data-type']).must_equal 'GPU'
      end

      it 'contains links to and info on the project’s tasks' do
        get "/projects/#{gimps.id}"
        links = doc.css('#tasks a[data-class=task]')
        _(links.size).must_equal 2
        _(links.at("[data-id='#{three.id}']")['href'])
          .must_equal "/tasks/#{three.id}"
        _(links.at("[data-id='#{three.id}']")['data-done'])
          .must_equal 'false'
        _(links.at("[data-id='#{seven.id}']")['data-done'])
          .must_equal 'true'
      end
    end

    describe 'POST /projects' do
      it 'creates a new project with the given name and id' do
        post '/projects', id: id = UUID.new, name: 'ECC'
        project = Project.new(id: id, name: 'ECC')
        _(project_repo).must_have_received :<<, [project]
      end

      it 'redirects to /projects' do
        post '/projects', id: UUID.new, name: 'ECC'
        follow_redirect!
        _(URI(last_request.url).path).must_equal '/projects'
      end
    end

    describe 'POST /projects/dispatch' do
      it 'dispatches tasks to all free clients' do
        post '/projects/dispatch'
        _(task_dispatcher).must_have_received :dispatch_all, []
      end

      it 'redirects to /projects' do
        post '/projects/dispatch'
        follow_redirect!
        _(URI(last_request.url).path).must_equal '/projects'
      end
    end
  end
end
