# frozen_string_literal: true

require_relative 'dispatch'
require_relative 'message'
require_relative 'net_dispatcher'
require_relative 'repos'

module Kamerling
  class TaskDispatcher
    def initialize(net_dispatcher: NetDispatcher, repos: Repos)
      @net_dispatcher = net_dispatcher
      @repos          = repos
    end

    def dispatch_all
      repos.project_repo.all.each do |project|
        repos.client_repo.free_for_project(project.uuid).each do |client|
          task = repos.next_task_for(project)
          dispatch_task client: client, project: project, task: task if task
        end
      end
    end

    private

    attr_reader :net_dispatcher, :repos

    def dispatch_task(client:, project:, task:)
      message = Message.data(client: client, project: project, task: task)
      dispatch = Dispatch.new(addr: client.addr, client: client,
                              project: project, task: task)
      net_dispatcher.dispatch message.to_s, addr: client.addr
      client.busy = true
      repos << client
      repos << dispatch
    end
  end
end
