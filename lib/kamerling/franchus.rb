module Kamerling class Franchus
  def initialize(receiver: Boso.new, registrar: Yngo.new, repos: nil)
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
    client  = repos[:client][message.client_uuid]
    project = repos[:project][message.project_uuid]
    registrar.register client: client, project: project
  end

  def handle_RSLT message
    client = repos[:client][message.client_uuid]
    task   = repos[:task][message.task_uuid]
    receiver.receive client: client, result: message.data, task: task
  end
end end