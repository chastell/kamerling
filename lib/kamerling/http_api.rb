require 'sinatra/base'
require 'slim'

module Kamerling class HTTPAPI < Sinatra::Base
  enable :inline_templates

  get '/' do
    slim :root
  end
end end

__END__

@@ root
doctype html
html
  head
    title Kamerling
  body
    nav
      ul
        li
          a href='/projects' id='projects' projects
