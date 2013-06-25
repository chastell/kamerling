module Kamerling class TaskDispatcher
  def dispatch repos: Repos
    repos.projects.each do |project|
      repos.free_clients_for(project).each do |client|
        if task = repos.next_task_for(project)
          message = Messages::DATA[client: client, data: task.input,
            project: project, task: task]
          send "dispatch_to_#{client.addr.prot.downcase}", client, message
          client.busy = true
          repos << client
        end
      end
    end
  end

  private

  def dispatch_to_tcp client, message
    TCPSocket.open client.addr.host, client.addr.port do |socket|
      socket << message.input
    end
  end

  def dispatch_to_udp client, message
    UDPSocket.new.send message.input, 0, client.addr.host, client.addr.port
  end
end end
