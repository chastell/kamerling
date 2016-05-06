# frozen_string_literal: true

require_relative 'client_repo'
require_relative 'dispatch'
require_relative 'dispatch_repo'
require_relative 'message'
require_relative 'net_dispatcher'
require_relative 'project_repo'
require_relative 'task_repo'

module Kamerling
  class TaskDispatcher
    def initialize(client_repo: ClientRepo.new, dispatch_repo: DispatchRepo.new,
                   net_dispatcher: NetDispatcher, project_repo: ProjectRepo.new,
                   task_repo: TaskRepo.new)
      @client_repo    = client_repo
      @dispatch_repo  = dispatch_repo
      @project_repo   = project_repo
      @task_repo      = task_repo
      @net_dispatcher = net_dispatcher
    end

    def dispatch_all
      project_repo.all.each do |project|
        client_repo.free_for_project(project).each do |client|
          dispatch_task client: client, project: project
        end
      end
    end

    private

    attr_reader :client_repo, :dispatch_repo, :net_dispatcher, :project_repo,
                :task_repo

    def dispatch_task(client:, project:)
      task = task_repo.next_for_project(project)
      message = Message.data(client: client, project: project, task: task)
      dispatch = Dispatch.new(addr: client.addr, client: client,
                              project: project, task: task)
      net_dispatcher.dispatch message.to_s, addr: client.addr
      client.busy = true
      client_repo << client
      dispatch_repo << dispatch
    rescue TaskRepo::NotFound
      return
    end
  end
end
