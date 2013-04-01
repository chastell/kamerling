module Kamerling class Franchus
  def initialize(receiver: nil, registrar: Yngo.new, repos: nil)
    @receiver  = receiver
    @registrar = registrar
    @repos     = repos
  end

  def handle input
    message = Rainierus.new.decipher input
    send "handle_#{message.type}", message
  end

  attr_reader :receiver, :registrar, :repos
  private     :receiver, :registrar, :repos

  private

  def handle_RGST message
    client  = repos.fetch(:client).fetch message.client_uuid
    project = repos.fetch(:project).fetch message.project_uuid
    registrar.register client: client, project: project
  end

  def handle_RSLT message
    client  = repos.fetch(:client).fetch message.client_uuid
    project = repos.fetch(:project).fetch message.project_uuid
    task    = repos.fetch(:task).fetch message.task_uuid
    receiver.receive client: client, project: project, result: message.data,
      task: task
  end
end end
