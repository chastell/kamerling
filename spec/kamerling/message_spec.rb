require_relative '../spec_helper'
require_relative '../message_behaviour'

module Kamerling describe Message do
  include MessageBehaviour

  let(:mess) do
    Message.new "MESS\0\0\0\0\0\0\0\0\0\0\0\0" +
      '16B client  UUID16B project UUID16B task    UUIDsome payload'
  end

  describe '.[]' do
    it 'constructs a new message' do
      client  = fake :client,  uuid: UUID.new
      project = fake :project, uuid: UUID.new
      task    = fake :task,    uuid: UUID.new
      message = Message[client: client, payload: 'pay', project: project,
        task: task, type: 'MESS']
      message.client_uuid.must_equal client.uuid
      message.project_uuid.must_equal project.uuid
      message.task_uuid.must_equal task.uuid
      message.payload.must_equal 'pay'
      message.type.must_equal 'MESS'
    end
  end
end end
