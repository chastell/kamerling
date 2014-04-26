require_relative '../spec_helper'
require_relative '../../lib/kamerling/handler'
require_relative '../../lib/kamerling/uuid'

module Kamerling describe Handler do
  describe '#handle' do
    fakes :addr, :receiver, :registrar
    let(:handler) { Handler.new receiver: receiver, registrar: registrar }

    it 'handles RGST inputs' do
      input = 'RGST' + "\0" * 12 + '16B client  UUID16B project UUID'
      client_uuid  = UUID['16B client  UUID']
      project_uuid = UUID['16B project UUID']
      handler.handle input, addr
      args = {
        addr:         addr,
        client_uuid:  client_uuid,
        project_uuid: project_uuid,
      }
      registrar.must_have_received :register, [args]
    end

    it 'handles RSLT inputs' do
      input = 'RSLT' + "\0" * 12 +
        '16B client  UUID16B project UUID16B task    UUIDdata'
      client_uuid = UUID['16B client  UUID']
      task_uuid   = UUID['16B task    UUID']
      handler.handle input, addr
      args = {
        addr:        addr,
        client_uuid: client_uuid,
        data:        'data',
        task_uuid:   task_uuid,
      }
      receiver.must_have_received :receive, [args]
    end

    it 'raises on unknown inputs' do
      ex = -> { handler.handle 'MESS', addr }.must_raise Handler::UnknownInput
      ex.message.must_equal 'MESS'
    end
  end
end end
