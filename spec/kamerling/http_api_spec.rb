require 'nokogiri'

require_relative '../spec_helper'

module Kamerling describe HTTPAPI do
  let(:app) { HTTPAPI                           }
  let(:doc) { Nokogiri::HTML last_response.body }

  describe '/' do
    it 'contains a link to projects' do
      get '/'
      doc.css('#projects').first['href'].must_equal '/projects'
    end
  end

  describe '/projects' do
    it 'contains links to projects' do
      gimps = fake :project, uuid: UUID.new
      ecc   = fake :project, uuid: UUID.new
      app.set repos: fake(:repos, as: :class, projects: [gimps, ecc])
      get '/projects'
      links = doc.css('#projects a[rel=project]').map { |a| a['href'] }
      links.must_include "/projects/#{gimps.uuid}"
      links.must_include "/projects/#{ecc.uuid}"
    end
  end
end end
