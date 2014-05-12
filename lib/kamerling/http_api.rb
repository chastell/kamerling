require 'forwardable'
require 'sinatra/base'
require 'slim'
require_relative 'project'
require_relative 'repos'
require_relative 'uuid'

module Kamerling class HTTPAPI < Sinatra::Base
  extend Forwardable

  delegate repos: :settings

  configure { set repos: Repos }

  get '/' do
    render_template :root
  end

  get '/clients' do
    render_template :clients, locals: { clients: repos.clients }
  end

  get '/projects' do
    render_template :projects, locals: { projects: repos.projects }
  end

  get '/projects/:project_uuid' do
    project = repos.project params['project_uuid']
    clients = repos.clients_for project
    tasks   = repos.tasks_for project
    render_template :project, locals: { clients: clients, tasks: tasks }
  end

  post '/projects' do
    uuid = params.fetch('uuid') { UUID.new }
    repos << Project.new(name: params['name'], uuid: uuid)
    redirect '/projects'
  end

  private

  def render_template template, locals: {}
    warn_off { slim template, locals: locals }
  end
end end
