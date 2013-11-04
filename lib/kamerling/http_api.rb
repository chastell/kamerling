require 'sinatra/base'
require 'slim'

module Kamerling class HTTPAPI < Sinatra::Base
  get '/' do
    slim <<-end.gsub(/^ {6}/, '')
      doctype html
      html
        head
          title Kamerling
        body
          nav
            ul
              li
                a href='/projects' id='projects' projects
    end
  end
end end
