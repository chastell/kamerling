require_relative '../spec_helper'

module Kamerling describe Handler do
  describe '#handle' do
    fakes :addr, :registrar, :receiver

    it 'handles RGST inputs' do
      input = 'RGST' + "\0" * 12 + '16B client UUID 16B project UUID'
      Handler.new.handle input, addr, registrar: registrar
      registrar.must_have_received :register, [{ addr: addr,
        client_uuid: '16B client UUID ', project_uuid: '16B project UUID', repos: nil }]
    end

    it 'handles RSLT inputs' do
      input = 'RSLT' + "\0" * 12
      input << '16B client UUID 16B project UUID16B task UUID   data'
      Handler.new.handle input, addr, receiver: receiver
      receiver.must_have_received :receive, [{ addr: addr,
        client_uuid: '16B client UUID ', data: 'data', repos: nil,
        task_uuid: '16B task UUID   ' }]
    end
  end
end end
