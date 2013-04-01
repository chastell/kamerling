require_relative '../spec_helper'

module Kamerling describe Franchus do
  describe '#handle' do
    it 'raises on unknown messages' do
      -> { Franchus.new.handle 'MESS age' }.must_raise UnknownMessage
    end

    it 'handles known messages' do
      scribe   = double decipher: -> _ { double type: 'MESS' }
      franchus = Franchus.new
      def franchus.handle_MESS message
        message.type
      end
      franchus.handle('MESSage', scribe: scribe).must_equal 'MESS'
    end

    it 'handles RGST messages' do
      cuuid = '16B client UUID '
      puuid = '16B project UUID'
      repos = {
        client:  { cuuid => client  = double },
        project: { puuid => project = double },
      }
      registrar = MiniTest::Mock.new.expect :register, nil, [client, project]
      message   = "RGST" + "\0" * 12 + cuuid + puuid
      Franchus.new(registrar: registrar, repos: repos).handle message
      registrar.verify
    end

    it 'handles RSLT messages' do
      cuuid = '16B client UUID '
      puuid = '16B project UUID'
      tuuid = '16B task UUID   '
      repos = {
        client:  { cuuid => client  = double },
        project: { puuid => project = double },
        task:    { tuuid => task    = double },
      }
      receiver = MiniTest::Mock.new.expect :receive, nil, [client, project, task]
      message = "RSLT" + "\0" * 12 + cuuid + puuid + tuuid + 'data'
      Franchus.new(repos: repos, receiver: receiver).handle message
      receiver.verify
    end
  end
end end
