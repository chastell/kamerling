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

  get '/projects/:project_uuid' do
    project = settings.repos[Project][params['project_uuid']]
    tasks   = settings.repos[Task].related_to project
    warn_off { slim :project, locals: { tasks: tasks } }
  end

  post '/projects' do
    uuid = params.fetch('uuid') { UUID.new }
    settings.repos << Project.new(name: params['name'], uuid: uuid)
    redirect '/projects'
  end
end end
