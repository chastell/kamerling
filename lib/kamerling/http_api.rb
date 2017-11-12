require 'forwardable'
require 'sinatra/base'
require 'slim'
require_relative 'project'
require_relative 'repos'
require_relative 'task_dispatcher'
require_relative 'uuid'

module Kamerling
  class HTTPAPI < Sinatra::Base
    extend Forwardable

    delegate %i[repos task_dispatcher] => :settings

    configure do
      set repos: Repos.new, task_dispatcher: TaskDispatcher.new
    end

    get '/' do
      render_template :root
    end

    get '/clients' do
      render_template :clients, locals: { clients: repos.client_repo.all }
    end

    get '/projects' do
      render_template :projects, locals: { projects: repos.project_repo.all }
    end

    get '/projects/:project_id' do
      project_id = params['project_id']
      clients = repos.client_repo.for_project(Project.new(id: project_id))
      tasks   = repos.task_repo.for_project(Project.new(id: project_id))
      render_template :project, locals: { clients: clients, tasks: tasks }
    end

    post '/projects' do
      name = params.fetch('name')
      id   = params.fetch('id')
      repos.project_repo << Project.new(id: id, name: name)
      redirect '/projects'
    end

    post '/projects/dispatch' do
      task_dispatcher.dispatch_all
      redirect '/projects'
    end

    private

    def render_template(template, locals: {})
      slim template, locals: locals
    end
  end
end
