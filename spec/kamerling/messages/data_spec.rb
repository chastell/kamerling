require_relative '../../spec_helper'
require_relative '../../message_behaviour'

module Kamerling module Messages describe RGST do
  let(:mess) { DATA.new "DATA\0\0\0\0\0\0\0\0\0\0\0\0" +
    '16B client  UUID16B project UUID16B task    UUIDsome-length data' }
  include MessageBehaviour

  describe '.[]' do
    it 'constructs a new DATA message' do
      client  = fake :client,  uuid: UUID.new
      project = fake :project, uuid: UUID.new
      task    = fake :task,    uuid: UUID.new
      mess    = DATA[client: client, data: 'data', project: project, task: task]
      mess.client_uuid.must_equal client.uuid
      mess.project_uuid.must_equal project.uuid
      mess.task_uuid.must_equal task.uuid
      mess.data.must_equal 'data'
    end
  end
end end end
