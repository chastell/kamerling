require_relative '../spec_helper'

module Kamerling describe Handler do
  describe '#handle' do
    fake :addr
    fake :client
    fake :project
    fake :task
    let(:repos) { {
      clients:  { '16B client UUID ' => client  },
      projects: { '16B project UUID' => project },
      tasks:    { '16B task UUID   ' => task    },
    } }

    it 'handles RGST inputs' do
      input = 'RGST' + "\0" * 12 + '16B client UUID 16B project UUID'
      registrar = fake :registrar
      Handler.new(registrar: registrar, repos: repos).handle input, addr
      registrar.must_have_received :register,
        [{ addr: addr, client: client, project: project, repos: repos }]
    end

    it 'handles RSLT inputs' do
      input = 'RSLT' + "\0" * 12
      input << '16B client UUID 16B project UUID16B task UUID   data'
      receiver = fake :receiver
      Handler.new(receiver: receiver, repos: repos).handle input, addr
      receiver.must_have_received :receive,
        [{ client: client, data: 'data', repos: repos, task: task }]
    end
  end
end end
