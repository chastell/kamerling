require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/uuid'

module Kamerling                          # rubocop:disable Metrics/ModuleLength
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
        _(message.client_uuid).must_equal client.uuid
        _(message.project_uuid).must_equal project.uuid
        _(message.task_uuid).must_equal task.uuid
        _(message.payload).must_equal 'pay'
        _(message.type).must_equal :DATA
      end
    end

    describe '.data' do
      it 'constructs a new DATA message' do
        client  = Client.new
        project = Project.new
        task    = Task.new(data: 'pay')
        message = Message.data(client: client, project: project, task: task)
        _(message.client_uuid).must_equal client.uuid
        _(message.project_uuid).must_equal project.uuid
        _(message.task_uuid).must_equal task.uuid
        _(message.payload).must_equal 'pay'
        _(message.type).must_equal :DATA
      end
    end

    describe '.parse' do
      it 'raises on unknown message types' do
        _(-> { Message.parse('MESS age') }).must_raise Message::UnknownType
      end
    end

    describe '.rgst' do
      it 'constructs a new RGST message' do
        client  = Client.new
        project = Project.new
        message = Message.rgst(client: client, project: project)
        _(message.client_uuid).must_equal client.uuid
        _(message.project_uuid).must_equal project.uuid
        _(message.type).must_equal :RGST
      end
    end

    describe '.rslt' do
      it 'constructs a new RSLT message' do
        client  = Client.new
        task    = Task.new(project: Project.new)
        message = Message.rslt(client: client, payload: 'data', task: task)
        _(message.client_uuid).must_equal client.uuid
        _(message.payload).must_equal 'data'
        _(message.task_uuid).must_equal task.uuid
        _(message.type).must_equal :RSLT
      end
    end

    describe '#client_type' do
      it 'returns the client’s type' do
        _(mess.client_type).must_equal :"\0\0\0\0"
        fpga_mess = Message.parse("RGSTFPGA\0\0\0\0\0\0\0\0" \
                                  '16B client  UUID16B project UUID' \
                                  '16B task    UUID')
        _(fpga_mess.client_type).must_equal :FPGA
      end
    end

    describe '#client_uuid' do
      it 'returns the client UUID' do
        _(mess.client_uuid).must_equal '31364220-636c-6965-6e74-202055554944'
      end
    end

    describe '#payload' do
      it 'returns the result payload' do
        _(mess.payload).must_equal 'some payload'
      end
    end

    describe '#project_uuid' do
      it 'returns the project UUID' do
        _(mess.project_uuid).must_equal '31364220-7072-6f6a-6563-742055554944'
      end
    end

    describe '#task_uuid' do
      it 'returns the task UUID' do
        _(mess.task_uuid).must_equal '31364220-7461-736b-2020-202055554944'
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
        _(mess.to_s).must_equal "#{mess.type}\0\0\0\0\0\0\0\0\0\0\0\0" \
          '16B client  UUID16B project UUID16B task    UUIDsome payload'
      end
    end

    describe '#type' do
      it 'returns the message type' do
        _(mess.type).must_match(/\A[A-Z]{4}\z/)
      end
    end
  end
end
