module Kamerling class TaskDispatcher
  def initialize net_dispatcher: NetDispatcher, repos: Repos
    @net_dispatcher = net_dispatcher
    @repos          = repos
  end

  def dispatch
    repos.projects.each do |project|
      repos.free_clients_for(project).each do |client|
        task = repos.next_task_for(project)
        dispatch_task client: client, project: project, task: task if task
      end
    end
  end

  attr_reader :net_dispatcher, :repos
  private     :net_dispatcher, :repos

  private

  def dispatch_task client: req(:client), project: req(:project),
                    task: req(:task)
    message = Message[client: client, payload: task.data, project: project,
                      task: task, type: :DATA]
    net_dispatcher.dispatch client.addr, message.to_s
    client.busy = true
    repos << client
  end
end end
