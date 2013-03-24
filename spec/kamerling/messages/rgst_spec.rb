require_relative '../../spec_helper'

module Kamerling module Messages describe RGST do
  describe '#client_uuid' do
    it 'returns the client UUID' do
      cuuid = '16 B client UUID'
      rgst  = RGST.new 'RGST' + "\0" * 12 + cuuid
      rgst.client_uuid.must_equal cuuid
    end
  end

  describe '#project_uuid' do
    it 'returns the project UUID' do
      puuid = '16 B projectUUID'
      rgst  = RGST.new 'RGST' + "\0" * 12 + "\0" * 16 + puuid
      rgst.project_uuid.must_equal puuid
    end
  end

  describe '#type' do
    it 'returns the message type' do
      RGST.new('RGST').type.must_equal 'RGST'
    end
  end
end end end
