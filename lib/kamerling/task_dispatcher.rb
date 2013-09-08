module Kamerling class TaskDispatcher
  def initialize repos: Repos
    @repos = repos
  end

  def dispatch
    repos.projects.each do |project|
      repos.free_clients_for(project).each do |client|
        task = repos.next_task_for(project)
        dispatch_task client: client, project: project, task: task if task
      end
    end
  end

  attr_reader :repos
  private     :repos

  private

  def dispatch_task client: req(:client), project: req(:project),
                    task: req(:task)
    message = Messages::DATA[client: client, payload: task.data,
      project: project, task: task]
    send "dispatch_to_#{client.addr.prot.downcase}", client, message
    client.busy = true
    repos << client
  end

  def dispatch_to_tcp client, message
    TCPSocket.open(*client.addr) do |socket|
      socket << message.raw
    end
  end

  def dispatch_to_udp client, message
    UDPSocket.new.send message.raw, 0, *client.addr
  end
end end
