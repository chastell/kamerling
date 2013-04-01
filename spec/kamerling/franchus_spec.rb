require_relative '../spec_helper'

module Kamerling describe Franchus do
  describe '#handle' do
    it 'handles RGST inputs' do
      cuuid = '16B client UUID '
      puuid = '16B project UUID'
      repos = {
        client:  { cuuid => client  = double },
        project: { puuid => project = double },
      }
      registrar = MiniTest::Mock.new
      registrar.expect :register, nil, [{ client: client, project: project }]
      input = "RGST" + "\0" * 12 + cuuid + puuid
      Franchus.new(registrar: registrar, repos: repos).handle input
      registrar.verify
    end

    it 'handles RSLT inputs' do
      cuuid = '16B client UUID '
      puuid = '16B project UUID'
      tuuid = '16B task UUID   '
      repos = {
        client:  { cuuid => client  = double },
        project: { puuid => project = double },
        task:    { tuuid => task    = double },
      }
      receiver = MiniTest::Mock.new
      receiver.expect :receive, nil, [{ client: client, project: project, task: task }]
      input = "RSLT" + "\0" * 12 + cuuid + puuid + tuuid + 'data'
      Franchus.new(repos: repos, receiver: receiver).handle input
      receiver.verify
    end
  end
end end
