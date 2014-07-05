require 'nokogiri'
require_relative '../spec_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/http_api'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/repos'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/uuid'

module Kamerling describe HTTPAPI do
  let(:app)   { HTTPAPI.set repos: repos                        }
  let(:doc)   { Nokogiri::HTML last_response.body               }
  let(:ecc)   { fake :project, uuid: UUID.new                   }
  let(:gimps) { fake :project, uuid: UUID.new                   }
  let(:repos) { fake :repos, as: :class, projects: [gimps, ecc] }

  describe 'GET /' do
    it 'contains links to clients and projects' do
      get '/'
      doc.at('#clients')['href'].must_equal '/clients'
      doc.at('#projects')['href'].must_equal '/projects'
    end
  end

  describe 'GET /clients' do
    it 'contains links to and UUIDs of clients' do
      fpga = fake :client, uuid: UUID.new
      stub(repos).clients { [fpga] }
      get '/clients'
      links = doc.css '#clients a[data-type=client]'
      links.first['data-uuid'].must_equal fpga.uuid
      links.first['href'].must_equal "/clients/#{fpga.uuid}"
    end
  end

  describe 'GET /projects' do
    it 'contains links to and UUIDs of projects' do
      get '/projects'
      links = doc.css '#projects a[data-type=project]'
      links.size.must_equal 2
      links.at("[data-uuid='#{gimps.uuid}']")['href']
        .must_equal "/projects/#{gimps.uuid}"
    end
  end

  describe 'GET /projects/{uuid}' do
    let(:cpu) { fake :client, busy: false, uuid: UUID.new }
    let(:gpu) { fake :client, busy: true,  uuid: UUID.new }
    let(:three) { fake :task, done: false, uuid: UUID.new }
    let(:seven) { fake :task, done: true,  uuid: UUID.new }

    before do
      stub(repos).project(gimps.uuid) { gimps          }
      stub(repos).clients_for(gimps)  { [cpu, gpu]     }
      stub(repos).tasks_for(gimps)    { [three, seven] }
    end

    it 'contains links to and info on the project’s clients' do
      get "/projects/#{gimps.uuid}"
      links = doc.css '#clients a[data-type=client]'
      links.size.must_equal 2
      links.at("[data-uuid='#{cpu.uuid}']")['href']
        .must_equal "/clients/#{cpu.uuid}"
      links.at("[data-uuid='#{cpu.uuid}']")['data-busy'].must_equal 'false'
      links.at("[data-uuid='#{gpu.uuid}']")['data-busy'].must_equal 'true'
    end

    it 'contains links to and info on the project’s tasks' do
      get "/projects/#{gimps.uuid}"
      links = doc.css '#tasks a[data-type=task]'
      links.size.must_equal 2
      links.at("[data-uuid='#{three.uuid}']")['href']
        .must_equal "/tasks/#{three.uuid}"
      links.at("[data-uuid='#{three.uuid}']")['data-done'].must_equal 'false'
      links.at("[data-uuid='#{seven.uuid}']")['data-done'].must_equal 'true'
    end
  end

  describe 'POST /projects' do
    it 'creates a new project with the given name and UUID' do
      post '/projects', name: 'ECC', uuid: uuid = UUID.new
      repos.must_have_received :<<, [Project.new(name: 'ECC', uuid: uuid)]
    end

    it 'redirects to /projects' do
      post '/projects', name: 'ECC', uuid: UUID.new
      follow_redirect!
      URI(last_request.url).path.must_equal '/projects'
    end
  end
end end
