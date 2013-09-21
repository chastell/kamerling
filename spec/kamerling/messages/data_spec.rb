require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe DATA do
  include MessageBehaviour

  let(:mess) do
    DATA.new "DATA\0\0\0\0\0\0\0\0\0\0\0\0" +
      '16B client  UUID16B project UUID16B task    UUIDsome payload'
  end

  describe '.[]' do
    it 'constructs a new DATA message' do
      client  = fake :client,  uuid: UUID.new
      project = fake :project, uuid: UUID.new
      task    = fake :task,    uuid: UUID.new
      mess    = DATA[client: client, payload: 'pay', project: project,
        task: task, type: 'DATA']
      mess.client_uuid.must_equal client.uuid
      mess.project_uuid.must_equal project.uuid
      mess.task_uuid.must_equal task.uuid
      mess.payload.must_equal 'pay'
    end
  end
end end end
