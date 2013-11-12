require 'nokogiri'

require_relative '../spec_helper'

module Kamerling describe HTTPAPI do
  fake :repos, as: :class

  let(:app) { HTTPAPI.set repos: repos          }
  let(:doc) { Nokogiri::HTML last_response.body }

  describe 'GET /' do
    it 'contains a link to projects' do
      get '/'
      doc.css('#projects').first['href'].must_equal '/projects'
    end
  end

  describe 'GET /projects' do
    it 'contains links to projects' do
      gimps = fake :project, uuid: UUID.new
      ecc   = fake :project, uuid: UUID.new
      stub(repos).projects { [gimps, ecc] }
      get '/projects'
      links = doc.css('#projects a[rel=project]').map { |a| a['href'] }
      links.must_include "/projects/#{gimps.uuid}"
      links.must_include "/projects/#{ecc.uuid}"
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
