require_relative 'receiver'
require_relative 'registrar'

module Kamerling
  class Handler
    def initialize(receiver: Receiver, registrar: Registrar)
      @receiver  = receiver
      @registrar = registrar
    end

    def handle(message, addr:)
      case message.type
      when :RGST then registrar.register addr: addr, message: message
      when :RSLT then receiver.receive addr: addr, message: message
      end
    end

    private_attr_reader :receiver, :registrar
  end
end
