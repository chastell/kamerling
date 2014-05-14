require_relative 'message'
require_relative 'receiver'
require_relative 'registrar'

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
    when :RGST then registrar.register addr: addr, message: message
    when :RSLT then receiver.receive   addr: addr, message: message
    end
  end
end end
