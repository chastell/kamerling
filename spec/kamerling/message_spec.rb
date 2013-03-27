require_relative '../spec_helper'

module Kamerling describe Message do
  MESS = Class.new Message

  describe '#client_uuid' do
    it 'returns the client UUID' do
      cuuid = '16 B client UUID'
      mess  = MESS.new 'MESS' + "\0" * 12 + cuuid
      mess.client_uuid.must_equal cuuid
    end
  end

  describe '#data' do
    it 'returns the result data' do
      mess = MESS.new 'MESS' + "\0" * (12 + 16 + 16 + 16) + 'data'
      mess.data.must_equal 'data'
    end
  end

  describe '#project_uuid' do
    it 'returns the project UUID' do
      puuid = '16 B projectUUID'
      mess  = MESS.new 'MESS' + "\0" * 12 + "\0" * 16 + puuid
      mess.project_uuid.must_equal puuid
    end
  end

  describe '#task_uuid' do
    it 'returns the task UUID' do
      tuuid = '16 B task   UUID'
      mess  = MESS.new 'MESS' + "\0" * 12 + "\0" * 16 + "\0" * 16 + tuuid
      mess.task_uuid.must_equal tuuid
    end
  end

  describe '#type' do
    it 'returns the message type' do
      MESS.new('MESS').type.must_equal 'MESS'
    end
  end
end end
