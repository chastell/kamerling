module Kamerling class Franchus
  def initialize(receiver: Boso.new, registrar: Yngo.new, repos: nil)
    @receiver  = receiver
    @registrar = registrar
    @repos     = repos
  end

  def handle input, addrinfo
    message = Rainierus.new.decipher input
    send "handle_#{message.type}", message, addrinfo
  end

  attr_reader :receiver, :registrar, :repos
  private     :receiver, :registrar, :repos

  private

  def handle_RGST message, addrinfo
    client  = repos[:clients][message.client_uuid]
    project = repos[:projects][message.project_uuid]
    registrar.register addrinfo: addrinfo, client: client, project: project
  end

  def handle_RSLT message, _
    client = repos[:clients][message.client_uuid]
    task   = repos[:tasks][message.task_uuid]
    receiver.receive client: client, data: message.data, task: task
  end
end end
