module Kamerling class Handler
  def initialize(receiver: Receiver.new, registrar: Registrar.new, repos: nil)
    @receiver  = receiver
    @registrar = registrar
    @repos     = repos
  end

  def handle input, addr
    message = Scribe.new.decipher input
    send "handle_#{message.type}", message, addr
  end

  attr_reader :receiver, :registrar, :repos
  private     :receiver, :registrar, :repos

  private

  def handle_RGST message, addr
    client  = repos[:clients][message.client_uuid]
    project = repos[:projects][message.project_uuid]
    registrar.register addr: addr, client: client, project: project,
      repos: repos
  end

  def handle_RSLT message, _
    client = repos[:clients][message.client_uuid]
    task   = repos[:tasks][message.task_uuid]
    receiver.receive client: client, data: message.data, repos: repos,
      task: task
  end
end end
