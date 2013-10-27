module Kamerling class Handler
  def initialize(receiver: Receiver.new, registrar: Registrar.new)
    @receiver, @registrar = receiver, registrar
  end

  def handle input, addr
    message = Message.new input
    case message.type
    when :RGST
      registrar.register addr: addr, client_uuid: message.client_uuid,
        project_uuid: message.project_uuid
    when :RSLT
      receiver.receive addr: addr, client_uuid: message.client_uuid,
        data: message.payload, task_uuid: message.task_uuid
    end
  rescue Message::UnknownType
  end

  attr_reader :receiver, :registrar
  private     :receiver, :registrar
end end
