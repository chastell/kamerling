# frozen_string_literal: true

require 'forwardable'
require 'sinatra/base'
require 'slim'
require_relative 'client_repo'
require_relative 'project'
require_relative 'project_repo'
require_relative 'task_dispatcher'
require_relative 'task_repo'
require_relative 'uuid'

module Kamerling
  class HTTPAPI < Sinatra::Base
    extend Forwardable

    delegate %i(client_repo project_repo task_dispatcher task_repo) => :settings

    configure do
      set client_repo: ClientRepo.new, project_repo: ProjectRepo.new,
          task_dispatcher: TaskDispatcher.new, task_repo: TaskRepo.new
    end

    get '/' do
      render_template :root
    end

    get '/clients' do
      render_template :clients, locals: { clients: client_repo.all }
    end

    get '/projects' do
      render_template :projects, locals: { projects: project_repo.all }
    end

    get '/projects/:project_uuid' do
      project_uuid = params['project_uuid']
      clients = client_repo.for_project(Project.new(uuid: project_uuid))
      tasks   = task_repo.for_project(Project.new(uuid: project_uuid))
      render_template :project, locals: { clients: clients, tasks: tasks }
    end

    post '/projects' do
      name = params.fetch('name')
      uuid = params.fetch('uuid')
      project_repo << Project.new(name: name, uuid: uuid)
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
