module Kamerling class TaskDispatcher
  def dispatch repos: Repos
    repos.projects.each do |project|
      repos.free_clients_for(project).each do |client|
        if task = repos.next_task_for(project)
          TCPSocket.open(*client.addr) do |socket|
            message = Messages::DATA[client: client, data: task.input,
              project: project, task: task]
            socket << message.input
          end
          client.busy = true
          repos << client
        end
      end
    end
  end
end end
