require 'sinatra/base'
require 'slim'

module Kamerling class HTTPAPI < Sinatra::Base
  configure { set repos: Repos }

  get '/' do
    slim :root
  end

  get '/projects' do
    warn_off { slim :projects, locals: { projects: settings.repos.projects } }
  end

  post '/projects' do
    uuid = params.fetch('uuid') { UUID.new }
    settings.repos << Project.new(name: params['name'], uuid: uuid)
    redirect '/projects'
  end
end end
