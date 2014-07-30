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
      name = params.fetch 'name'
      uuid = params.fetch 'uuid'
      repos << Project.new(name: name, uuid: uuid)
      redirect '/projects'
    end

    post '/projects/dispatch' do
      task_dispatcher.dispatch
      redirect '/projects'
    end

    private

    def render_template template, locals: {}
      warn_off { slim template, locals: locals }
    end
  end
end
