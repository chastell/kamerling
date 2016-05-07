# frozen_string_literal: true

require 'nokogiri'
require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/client_repo'
require_relative '../../lib/kamerling/http_api'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/project_repo'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/task_repo'
require_relative '../../lib/kamerling/task_dispatcher'
require_relative '../../lib/kamerling/uuid'

module Kamerling
  describe HTTPAPI do
    let(:client_repo)     { fake(ClientRepo)                     }
    let(:doc)             { Nokogiri::HTML(last_response.body)   }
    let(:ecc)             { Project.new                          }
    let(:gimps)           { Project.new                          }
    let(:project_repo)    { fake(ProjectRepo, all: [gimps, ecc]) }
    let(:task_dispatcher) { fake(TaskDispatcher)                 }
    let(:task_repo)       { fake(TaskRepo)                       }

    let(:app) do
      HTTPAPI.set(client_repo: client_repo, project_repo: project_repo,
                  task_dispatcher: task_dispatcher, task_repo: task_repo)
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
        addr = Addr['127.0.0.1', 1981, :TCP]
        fpga = Client.new(addr: addr, busy: true, type: :FPGA)
        stub(client_repo).all { [fpga] }
        get '/clients'
        links = doc.css('#clients a[data-class=client]')
        _(links.first['data-addr']).must_equal 'tcp://127.0.0.1:1981'
        _(links.first['data-busy']).must_equal 'true'
        _(links.first['data-type']).must_equal 'FPGA'
        _(links.first['data-uuid']).must_equal fpga.uuid
        _(links.first['href']).must_equal "/clients/#{fpga.uuid}"
      end
    end

    describe 'GET /projects' do
      it 'contains links to and UUIDs of projects' do
        get '/projects'
        links = doc.css('#projects a[data-class=project]')
        _(links.size).must_equal 2
        _(links.at("[data-uuid='#{gimps.uuid}']")['href'])
          .must_equal "/projects/#{gimps.uuid}"
      end
    end

    describe 'GET /projects/{uuid}' do
      let(:cpu) { Client.new(busy: false, type: :CPU) }
      let(:gpu) { Client.new(busy: true,  type: :GPU) }
      let(:three) { Task.new(done: false) }
      let(:seven) { Task.new(done: true)  }

      before do
        stub(client_repo).for_project(gimps) { [cpu, gpu] }
        stub(task_repo).for_project(gimps) { [three, seven] }
      end

      it 'contains links to and info on the project’s clients' do
        get "/projects/#{gimps.uuid}"
        links = doc.css('#clients a[data-class=client]')
        _(links.size).must_equal 2
        _(links.at("[data-uuid='#{cpu.uuid}']")['href'])
          .must_equal "/clients/#{cpu.uuid}"
        _(links.at("[data-uuid='#{cpu.uuid}']")['data-busy']).must_equal 'false'
        _(links.at("[data-uuid='#{gpu.uuid}']")['data-busy']).must_equal 'true'
        _(links.at("[data-uuid='#{cpu.uuid}']")['data-type']).must_equal 'CPU'
        _(links.at("[data-uuid='#{gpu.uuid}']")['data-type']).must_equal 'GPU'
      end

      it 'contains links to and info on the project’s tasks' do
        get "/projects/#{gimps.uuid}"
        links = doc.css('#tasks a[data-class=task]')
        _(links.size).must_equal 2
        _(links.at("[data-uuid='#{three.uuid}']")['href'])
          .must_equal "/tasks/#{three.uuid}"
        _(links.at("[data-uuid='#{three.uuid}']")['data-done'])
          .must_equal 'false'
        _(links.at("[data-uuid='#{seven.uuid}']")['data-done'])
          .must_equal 'true'
      end
    end

    describe 'POST /projects' do
      it 'creates a new project with the given name and UUID' do
        post '/projects', name: 'ECC', uuid: uuid = UUID.new
        _(project_repo).must_have_received :<<, [Project.new(uuid: uuid)]
      end

      it 'redirects to /projects' do
        post '/projects', name: 'ECC', uuid: UUID.new
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
