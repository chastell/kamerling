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

    delegate %i(task_dispatcher repos) => :settings

    configure { set task_dispatcher: TaskDispatcher.new, repos: Repos }

    get '/' do
      render_template :root
    end

    get '/clients' do
      render_template :clients, locals: { clients: repos.client_repo.all }
    end

    get '/projects' do
      render_template :projects, locals: { projects: repos.project_repo.all }
    end

    get '/projects/:project_uuid' do
      project_uuid = params['project_uuid']
      project = repos.project_repo.fetch_with_clients_and_tasks(project_uuid)
      locals  = { clients: project.clients, tasks: project.tasks }
      render_template :project, locals: locals
    end

    post '/projects' do
      name = params.fetch('name')
      uuid = params.fetch('uuid')
      repos.project_repo << Project.new(name: name, uuid: uuid)
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
