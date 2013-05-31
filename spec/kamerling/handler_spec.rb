require_relative '../spec_helper'

module Kamerling describe Handler do
  describe '#handle' do
    fakes :addr, :registrar, :receiver
    let(:handler) { Handler.new }

    it 'handles RGST inputs' do
      input = 'RGST' + "\0" * 12 + '16B client  UUID16B project UUID'
      handler.handle input, addr, registrar: registrar
      registrar.must_have_received :register, [{ addr: addr,
        client_uuid: UUID.from_bin('16B client  UUID'),
        project_uuid: UUID.from_bin('16B project UUID') }]
    end

    it 'handles RSLT inputs' do
      input = 'RSLT' + "\0" * 12
      input << '16B client  UUID16B project UUID16B task    UUIDdata'
      handler.handle input, addr, receiver: receiver
      receiver.must_have_received :receive, [{ addr: addr,
        client_uuid: UUID.from_bin('16B client  UUID'), data: 'data',
        task_uuid: UUID.from_bin('16B task    UUID') }]
    end

    it 'raises on undecipherable inputs' do
      -> { handler.handle 'MESS age', addr }.must_raise Handler::UnknownInput
    end
  end
end end
