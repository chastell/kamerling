require_relative 'receiver'
require_relative 'registrar'

module Kamerling class Handler
  def initialize receiver: Receiver.new, registrar: Registrar.new
    @receiver, @registrar = receiver, registrar
  end

  def handle message, addr
    process message, addr
  end

  attr_reader :receiver, :registrar
  private     :receiver, :registrar

  private

  def process message, addr
    case message.type
    when :RGST then registrar.register addr: addr, message: message
    when :RSLT then receiver.receive   addr: addr, message: message
    end
  end
end end
