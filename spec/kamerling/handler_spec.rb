require_relative '../spec_helper'

module Kamerling describe Handler do
  describe '#handle' do
    fakes :addr, :client, :project, :registrar, :receiver, :task

    let(:repos) { {
      Client  => { '16B client UUID ' => client  },
      Project => { '16B project UUID' => project },
      Task    => { '16B task UUID   ' => task    },
    } }

    it 'handles RGST inputs' do
      input = 'RGST' + "\0" * 12 + '16B client UUID 16B project UUID'
      Handler.new(registrar: registrar, repos: repos).handle input, addr
      registrar.must_have_received :register,
        [{ addr: addr, client: client, project: project, repos: repos }]
    end

    it 'handles RSLT inputs' do
      input = 'RSLT' + "\0" * 12
      input << '16B client UUID 16B project UUID16B task UUID   data'
      Handler.new(receiver: receiver, repos: repos).handle input, addr
      receiver.must_have_received :receive,
        [{ client: client, data: 'data', repos: repos, task: task }]
    end
  end
end end
