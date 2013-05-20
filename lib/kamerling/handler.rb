module Kamerling class Handler
  UnknownInput = Class.new RuntimeError

  def handle input, addr, receiver: Receiver.new, registrar: Registrar.new
    message = Messages.const_get(input[0..3]).new input
    case message.type
    when 'RGST'
      registrar.register addr: addr, client_uuid: message.client_uuid,
        project_uuid: message.project_uuid
    when 'RSLT'
      receiver.receive addr: addr, client_uuid: message.client_uuid,
        data: message.data, task_uuid: message.task_uuid
    end
  rescue NameError
    raise UnknownInput, input
  end
end end
