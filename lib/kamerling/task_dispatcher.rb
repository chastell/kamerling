module Kamerling class TaskDispatcher
  def dispatch repos: Repos
    repos.projects.each do |project|
      repos.free_clients_for(project).each do |client|
        if task = repos.next_task_for(project)
          message = Messages::DATA[client: client, data: task.input,
            project: project, task: task]
          case client.addr.prot
          when 'TCP'
            TCPSocket.open client.addr.host, client.addr.port do |socket|
              socket << message.input
            end
          when 'UDP'
            socket = UDPSocket.new
            socket.send message.input, 0, client.addr.host, client.addr.port
          end
          client.busy = true
          repos << client
        end
      end
    end
  end
end end
