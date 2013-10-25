module Kamerling class TaskDispatcher
  def initialize(repos: Repos)
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

  def dispatch_task(client: req(:client), project: req(:project),
                    task: req(:task))
    message = Message[client: client, payload: task.data, project: project,
      task: task, type: :DATA]
    NetDispatcher.new(client.addr).dispatch message
    client.busy = true
    repos << client
  end

  class NetDispatcher
    def initialize addr
      @addr = addr
    end

    def dispatch message
      case addr.prot
      when :TCP then TCPSocket.open(*addr) { |socket| socket << message.raw }
      when :UDP then UDPSocket.new.send message.raw, 0, *addr
      end
    end

    attr_reader :addr
    private     :addr
  end
end end
