module Kamerling class Handler
  def handle input, addr, receiver: Receiver.new, registrar: Registrar.new
    message = Scribe.new.decipher input

    case message.type
    when 'RGST'
      registrar.register addr: addr, client_uuid: message.client_uuid,
        project_uuid: message.project_uuid
    when 'RSLT'
      receiver.receive addr: addr, client_uuid: message.client_uuid,
        data: message.data, task_uuid: message.task_uuid
    end
  end
end end
