require_relative 'receiver'
require_relative 'registrar'

module Kamerling
  class Handler
    def initialize(receiver: Receiver, registrar: Registrar.new)
      @receiver, @registrar = receiver, registrar
    end

    def handle(message, addr)
      case message.type
      when :RGST then registrar.register addr: addr, message: message
      when :RSLT then receiver.receive   addr: addr, message: message
      end
    end

    attr_reader :receiver, :registrar
    private     :receiver, :registrar
  end
end
