require_relative '../spec_helper'

module Kamerling describe Message do
  MESS = Class.new Message

  let(:cuuid) { '16 B client UUID' }
  let(:puuid) { '16 B projectUUID' }
  let(:tuuid) { '16 B task   UUID' }

  let(:mess) { MESS.new 'MESS' + "\0" * 12 + cuuid + puuid + tuuid + 'data' }

  describe '#client_uuid' do
    it 'returns the client UUID' do
      mess.client_uuid.must_equal cuuid
    end
  end

  describe '#data' do
    it 'returns the result data' do
      mess.data.must_equal 'data'
    end
  end

  describe '#project_uuid' do
    it 'returns the project UUID' do
      mess.project_uuid.must_equal puuid
    end
  end

  describe '#task_uuid' do
    it 'returns the task UUID' do
      mess.task_uuid.must_equal tuuid
    end
  end

  describe '#type' do
    it 'returns the message type' do
      MESS.new('MESS').type.must_equal 'MESS'
    end
  end
end end
