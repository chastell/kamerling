require_relative '../test_helper'
require_relative '../../lib/kamerling/addr'
require_relative '../../lib/kamerling/handler'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/receiver'
require_relative '../../lib/kamerling/registrar'
require_relative '../../lib/kamerling/uuid'

module Kamerling
  describe Handler do
    describe '#handle' do
      fake :receiver,  as: :class
      fake :registrar, as: :class

      let(:addr)    { Addr.new                                              }
      let(:handler) { Handler.new(receiver: receiver, registrar: registrar) }

      it 'handles RGST inputs' do
        message = Message.parse('RGST')
        handler.handle message, addr: addr
        registrar.must_have_received :register, [addr: addr, message: message]
      end

      it 'handles RSLT inputs' do
        message = Message.parse('RSLT')
        handler.handle message, addr: addr
        receiver.must_have_received :receive, [addr: addr, message: message]
      end
    end
  end
end