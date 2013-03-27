require_relative '../../spec_helper'

module Kamerling module Messages describe RSLT do
  describe '#client_uuid' do
    it 'returns the client UUID' do
      cuuid = '16 B client UUID'
      rslt  = RSLT.new 'RSLT' + "\0" * 12 + cuuid
      rslt.client_uuid.must_equal cuuid
    end
  end

  describe '#data' do
    it 'returns the result data' do
      rslt = RSLT.new 'RSLT' + "\0" * (12 + 16 + 16 + 16) + 'data'
      rslt.data.must_equal 'data'
    end
  end

  describe '#project_uuid' do
    it 'returns the project UUID' do
      puuid = '16 B projectUUID'
      rslt  = RSLT.new 'RSLT' + "\0" * 12 + "\0" * 16 + puuid
      rslt.project_uuid.must_equal puuid
    end
  end

  describe '#task_uuid' do
    it 'returns the task UUID' do
      tuuid = '16 B task   UUID'
      rslt  = RSLT.new 'RSLT' + "\0" * 12 + "\0" * 16 + "\0" * 16 + tuuid
      rslt.task_uuid.must_equal tuuid
    end
  end

  describe '#type' do
    it 'returns the message type' do
      RSLT.new('RSLT').type.must_equal 'RSLT'
    end
  end
end end end
