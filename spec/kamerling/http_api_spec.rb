require 'nokogiri'

require_relative '../spec_helper'

module Kamerling describe HTTPAPI do
  let(:app)   { HTTPAPI.set repos: repos                        }
  let(:doc)   { Nokogiri::HTML last_response.body               }
  let(:ecc)   { fake :project, uuid: UUID.new                   }
  let(:gimps) { fake :project, uuid: UUID.new                   }
  let(:repos) { fake :repos, as: :class, projects: [gimps, ecc] }

  describe 'GET /' do
    it 'contains a link to projects' do
      get '/'
      doc.at('#projects')['href'].must_equal '/projects'
    end
  end

  describe 'GET /clients' do
    it 'contains links to and UUIDs of clients' do
      fpga = fake :client, uuid: UUID.new
      stub(repos).clients { [fpga] }
      get '/clients'
      links = doc.css '#clients a[rel=client]'
      links.size.must_equal 1
      links.at("[data-uuid='#{fpga.uuid}']")['href']
        .must_equal "/clients/#{fpga.uuid}"
    end
  end

  describe 'GET /projects' do
    it 'contains links to and UUIDs of projects' do
      get '/projects'
      links = doc.css '#projects a[rel=project]'
      links.size.must_equal 2
      links.at("[data-uuid='#{gimps.uuid}']")['href']
        .must_equal "/projects/#{gimps.uuid}"
    end
  end

  describe 'GET /projects/{uuid}' do
    it 'contains links to and info on the project’s tasks' do
      three = fake :task, done: false, uuid: UUID.new
      seven = fake :task, done: true,  uuid: UUID.new
      stub(repos).tasks_for(project_uuid: gimps.uuid) { [three, seven] }
      get "/projects/#{gimps.uuid}"
      links = doc.css '#tasks a[rel=task]'
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

    it 'creates a new project with a random UUID if missing' do
      post '/projects', name: 'ECC'
      project = Project.new name: 'ECC', uuid: any(String)
      repos.must_have_received :<<, [project]
    end

    it 'redirects to /projects' do
      post '/projects', name: 'ECC'
      follow_redirect!
      URI(last_request.url).path.must_equal '/projects'
    end
  end
end end
