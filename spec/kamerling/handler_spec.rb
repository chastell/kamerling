require_relative '../spec_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/handler'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/receiver'
require_relative '../../lib/kamerling/registrar'
require_relative '../../lib/kamerling/uuid'

module Kamerling describe Handler do
  describe '#handle' do
    fakes :addr, :receiver, :registrar

    let(:handler) { Handler.new receiver: receiver, registrar: registrar }

    it 'handles RGST inputs' do
      input = 'RGST' + "\0" * 12 + '16B client  UUID16B project UUID'
      message = Message.new input
      handler.handle input, addr
      registrar.must_have_received :register, [addr: addr, message: message]
    end

    it 'handles RSLT inputs' do
      input = 'RSLT' + "\0" * 12 +
        '16B client  UUID16B project UUID16B task    UUIDdata'
      message = Message.new input
      handler.handle input, addr
      receiver.must_have_received :receive, [addr: addr, message: message]
    end

    it 'raises on unknown inputs' do
      ex = -> { handler.handle 'MESS', addr }.must_raise Handler::UnknownInput
      ex.message.must_equal 'MESS'
    end
  end
end end
