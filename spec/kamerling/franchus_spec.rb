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
      client = MiniTest::Mock.new.expect :project=, nil, [project = double]
      cuuid = '16 B client UUID'
      puuid = '16 B projectUUID'
      crepo = { cuuid => client  }
      prepo = { puuid => project }
      message = "RGST" + "\0" * 12 + cuuid + puuid
      Franchus.new(client_repo: crepo, project_repo: prepo).handle message
      client.verify
    end
  end
end end
