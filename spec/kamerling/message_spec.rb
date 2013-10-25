require_relative '../spec_helper'

module Kamerling describe Message do
  let(:mess) do
    Message.new "DATA\0\0\0\0\0\0\0\0\0\0\0\0" +
      '16B client  UUID16B project UUID16B task    UUIDsome payload'
  end

  describe '.[]' do
    it 'constructs a new message' do
      client  = fake :client,  uuid: UUID.new
      project = fake :project, uuid: UUID.new
      task    = fake :task,    uuid: UUID.new
      message = Message[client: client, payload: 'pay', project: project,
        task: task, type: :DATA]
      message.client_uuid.must_equal client.uuid
      message.project_uuid.must_equal project.uuid
      message.task_uuid.must_equal task.uuid
      message.payload.must_equal 'pay'
      message.type.must_equal :DATA
    end
  end

  describe '.new' do
    it 'raises on unknown message types' do
      -> { Message.new 'MESS age' }.must_raise Message::UnknownType
    end
  end

  describe '#client_uuid' do
    it 'returns the client UUID' do
      mess.client_uuid.must_equal '31364220-636c-6965-6e74-202055554944'
    end
  end

  describe '#payload' do
    it 'returns the result payload' do
      mess.payload.must_equal 'some payload'
    end
  end

  describe '#project_uuid' do
    it 'returns the project UUID' do
      mess.project_uuid.must_equal '31364220-7072-6f6a-6563-742055554944'
    end
  end

  describe '#task_uuid' do
    it 'returns the task UUID' do
      mess.task_uuid.must_equal '31364220-7461-736b-2020-202055554944'
    end
  end

  describe '#to_s' do
    it 'returns the raw bytes' do
      mess.to_s.must_equal "#{mess.type}\0\0\0\0\0\0\0\0\0\0\0\0" +
        '16B client  UUID16B project UUID16B task    UUIDsome payload'
    end
  end

  describe '#type' do
    it 'returns the message type' do
      mess.type.must_match(/\A[A-Z]{4}\z/)
    end
  end
end end
