require 'forwardable'
require 'sinatra/base'
require 'slim'

module Kamerling class HTTPAPI < Sinatra::Base
  extend Forwardable

  configure { set repos: Repos }

  get '/' do
    slim :root
  end

  get '/clients' do
    warn_off { slim :clients, locals: { clients: repos.clients } }
  end

  get '/projects' do
    warn_off { slim :projects, locals: { projects: repos.projects } }
  end

  get '/projects/:project_uuid' do
    project = repos.project params['project_uuid']
    clients = repos.clients_for project
    tasks   = repos.tasks_for project
    warn_off { slim :project, locals: { clients: clients, tasks: tasks } }
  end

  post '/projects' do
    uuid = params.fetch('uuid') { UUID.new }
    repos << Project.new(name: params['name'], uuid: uuid)
    redirect '/projects'
  end

  private

  delegate repos: :settings
end end
