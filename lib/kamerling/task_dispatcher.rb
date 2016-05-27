# frozen_string_literal: true

require_relative 'dispatch'
require_relative 'message'
require_relative 'net_dispatcher'
require_relative 'settings'

module Kamerling
  class TaskDispatcher
    def initialize(net_dispatcher: NetDispatcher, settings: Settings.new)
      @net_dispatcher = net_dispatcher
      @settings       = settings
    end

    def dispatch_all
      settings.project_repo.all.each do |project|
        settings.client_repo.free_for_project(project).each do |client|
          dispatch_task client: client, project: project
        end
      end
    end

    private

    attr_reader :net_dispatcher, :settings

    def dispatch_task(client:, project:)
      task = settings.task_repo.next_for_project(project)
      message = Message.data(client: client, project: project, task: task)
      dispatch = Dispatch.new(addr: client.addr, client: client,
                              project: project, task: task)
      net_dispatcher.dispatch message.to_s, addr: client.addr
      client.busy = true
      settings.client_repo << client
      settings.dispatch_repo << dispatch
    rescue TaskRepo::NotFound
      return
    end
  end
end
