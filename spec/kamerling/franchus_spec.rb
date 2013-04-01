require_relative '../spec_helper'

module Kamerling describe Franchus do
  describe '#handle' do
    let(:client)  { double }
    let(:project) { double }
    let(:task)    { double }
    let(:repos) { {
      client:  { '16B client UUID ' => client  },
      project: { '16B project UUID' => project },
      task:    { '16B task UUID   ' => task    },
    } }

    it 'handles RGST inputs' do
      registrar = MiniTest::Mock.new
      registrar.expect :register, nil, [{ client: client, project: project }]
      input = 'RGST' + "\0" * 12 + '16B client UUID 16B project UUID'
      Franchus.new(registrar: registrar, repos: repos).handle input
      registrar.verify
    end

    it 'handles RSLT inputs' do
      receiver = MiniTest::Mock.new
      receiver.expect :receive, nil,
        [{ client: client, project: project, result: 'data', task: task }]
      input = 'RSLT' + "\0" * 12
      input << '16B client UUID 16B project UUID16B task UUID   data'
      Franchus.new(repos: repos, receiver: receiver).handle input
      receiver.verify
    end
  end
end end
