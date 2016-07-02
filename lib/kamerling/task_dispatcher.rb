# frozen_string_literal: true

require_relative 'message'
require_relative 'net_dispatcher'
require_relative 'repos'

module Kamerling
  class TaskDispatcher
    def initialize(net_dispatcher: NetDispatcher, repos: Repos.new)
      @net_dispatcher = net_dispatcher
      @repos          = repos
    end

    def dispatch_all
      repos.project_repo.all.each do |project|
        repos.client_repo.free_for_project(project).each do |client|
          begin
            task = repos.task_repo.next_for_project(project)
            dispatch_task client: client, project: project, task: task
          rescue TaskRepo::NotFound
            next
          end
        end
      end
    end

    private

    attr_reader :net_dispatcher, :repos

    def dispatch_task(client:, project:, task:)
      message = Message.data(client: client, project: project, task: task)
      net_dispatcher.dispatch message.to_s, addr: client.addr
      client.busy = true
      repos.client_repo << client
      repos.record_dispatch client: client, project: project, task: task
    end
  end
end
