require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/uuid'

module Kamerling
  describe Message do
    let(:mess) do
      Message.parse("DATA\0\0\0\0\0\0\0\0\0\0\0\0" \
        '16B client  UUID16B project UUID16B task    UUIDsome payload')
    end

    describe '.build' do
      it 'constructs a new message' do
        client  = Client.new
        project = Project.new
        task    = Task.new
        message = Message.build(client: client, payload: 'pay',
                                project: project, task: task, type: :DATA)
        message.client_uuid.must_equal client.uuid
        message.project_uuid.must_equal project.uuid
        message.task_uuid.must_equal task.uuid
        message.payload.must_equal 'pay'
        message.type.must_equal :DATA
      end
    end

    describe '.data' do
      it 'constructs a new DATA message' do
        client  = Client.new
        project = Project.new
        task    = Task.new(data: 'pay')
        message = Message.data(client: client, project: project, task: task)
        message.client_uuid.must_equal client.uuid
        message.project_uuid.must_equal project.uuid
        message.task_uuid.must_equal task.uuid
        message.payload.must_equal 'pay'
        message.type.must_equal :DATA
      end
    end

    describe '.parse' do
      it 'raises on unknown message types' do
        -> { Message.parse('MESS age') }.must_raise Message::UnknownType
      end

      it 'doesn’t raise on empty messages' do
        Message.parse('')
      end
    end

    describe '#client_type' do
      it 'returns the client’s type' do
        mess.client_type.must_equal :"\0\0\0\0"
        fpga_mess = Message.parse("RGSTFPGA\0\0\0\0\0\0\0\0" \
                                  '16B client  UUID16B project UUID' \
                                  '16B task    UUID')
        fpga_mess.client_type.must_equal :FPGA
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

    describe '#to_hex' do
      it 'returns a hex representation of the message' do
        assert mess.to_hex.start_with?('44 41 54 41')
        assert mess.to_hex.end_with?('70 61 79 6c 6f 61 64')
      end
    end

    describe '#to_s' do
      it 'returns the raw bytes' do
        mess.to_s.must_equal "#{mess.type}\0\0\0\0\0\0\0\0\0\0\0\0" \
          '16B client  UUID16B project UUID16B task    UUIDsome payload'
      end
    end

    describe '#type' do
      it 'returns the message type' do
        mess.type.must_match(/\A[A-Z]{4}\z/)
      end
    end
  end
end
