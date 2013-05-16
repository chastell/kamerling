module Kamerling class Handler
  def initialize(receiver: Receiver.new, registrar: Registrar.new, repos: {})
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
    registrar.register addr: addr, client_uuid: message.client_uuid,
      project_uuid: message.project_uuid, repos: repos
  end

  def handle_RSLT message, addr
    receiver.receive addr: addr, client_uuid: message.client_uuid,
      data: message.data, repos: repos, task_uuid: message.task_uuid
  end
end end
