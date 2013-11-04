require 'nokogiri'

require_relative '../spec_helper'

module Kamerling describe HTTPAPI do
  let(:app) { HTTPAPI }

  describe '/' do
    it 'contains a link to projects' do
      get '/'
      doc = Nokogiri::HTML last_response.body
      doc.css('#projects').first['href'].must_equal '/projects'
    end
  end
end end
