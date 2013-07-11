module Kamerling class Handler
  UnknownInput = Class.new RuntimeError

  def handle input, addr, receiver: Receiver.new, registrar: Registrar.new
    message = parse input
    case message.type
    when 'RGST'
      registrar.register addr: addr, client_uuid: message.client_uuid,
        project_uuid: message.project_uuid
    when 'RSLT'
      receiver.receive addr: addr, client_uuid: message.client_uuid,
        data: message.payload, task_uuid: message.task_uuid
    end
  end

  private

  def parse input
    Messages.const_get(input[0..3]).new input
  rescue NameError
    raise UnknownInput, input
  end
end end
