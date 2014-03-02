module Kamerling class Handler
  UnknownInput = Class.new RuntimeError

  def initialize receiver: Receiver.new, registrar: Registrar.new
    @receiver, @registrar = receiver, registrar
  end

  def handle input, addr
    process Message.new(input), addr
  rescue Message::UnknownType => exception
    raise UnknownInput, exception.message
  end

  attr_reader :receiver, :registrar
  private     :receiver, :registrar

  private

  def process message, addr
    case message.type
    when :RGST
      registrar.register addr: addr, client_uuid: message.client_uuid,
        project_uuid: message.project_uuid
    when :RSLT
      receiver.receive addr: addr, client_uuid: message.client_uuid,
        data: message.payload, task_uuid: message.task_uuid
    end
  end
end end
