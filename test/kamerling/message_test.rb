# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/kamerling/client'
require_relative '../../lib/kamerling/message'
require_relative '../../lib/kamerling/project'
require_relative '../../lib/kamerling/task'
require_relative '../../lib/kamerling/uuid'

module Kamerling                          # rubocop:disable Metrics/ModuleLength
  describe Message do
    let(:mess) do
      Message.new("DATA\0\0\0\0\0\0\0\0\0\0\0\0" \
        '16B client  UUID16B project UUID16B task    UUIDsome data')
    end

    describe '.build' do
      it 'constructs a new message' do
        client  = Client.new
        project = Project.new
        task    = Task.new
        message = Message.build(client: client, data: 'pay', project: project,
                                task: task, type: :DATA)
        _(message.client_id).must_equal client.id
        _(message.data).must_equal 'pay'
        _(message.project_id).must_equal project.id
        _(message.task_id).must_equal task.id
        _(message.type).must_equal :DATA
      end
    end

    describe '.data' do
      it 'constructs a new DATA message' do
        client  = Client.new
        project = Project.new
        task    = Task.new(data: 'pay')
        message = Message.data(client: client, project: project, task: task)
        _(message.client_id).must_equal client.id
        _(message.data).must_equal 'pay'
        _(message.project_id).must_equal project.id
        _(message.task_id).must_equal task.id
        _(message.type).must_equal :DATA
      end
    end

    describe '.new' do
      it 'raises on unknown message types' do
        _(-> { Message.new('MESS age') }).must_raise Message::UnknownType
      end
    end

    describe '.rgst' do
      it 'constructs a new RGST message' do
        client  = Client.new
        project = Project.new
        message = Message.rgst(client: client, project: project)
        _(message.client_id).must_equal client.id
        _(message.project_id).must_equal project.id
        _(message.type).must_equal :RGST
      end
    end

    describe '.rslt' do
      it 'constructs a new RSLT message' do
        client  = Client.new
        task    = Task.new(project: Project.new)
        message = Message.rslt(client: client, data: 'data', task: task)
        _(message.client_id).must_equal client.id
        _(message.data).must_equal 'data'
        _(message.task_id).must_equal task.id
        _(message.type).must_equal :RSLT
      end
    end

    describe '#client_type' do
      it 'returns the client’s type' do
        _(mess.client_type).must_equal :"\0\0\0\0"
        fpga_mess = Message.new("RGSTFPGA\0\0\0\0\0\0\0\0" \
                                '16B client  UUID16B project UUID' \
                                '16B task    UUID')
        _(fpga_mess.client_type).must_equal :FPGA
      end
    end

    describe '#client_id' do
      it 'returns the client id' do
        _(mess.client_id).must_equal '31364220-636c-6965-6e74-202055554944'
      end
    end

    describe '#data' do
      it 'returns the result data' do
        _(mess.data).must_equal 'some data'
      end
    end

    describe '#project_id' do
      it 'returns the project id' do
        _(mess.project_id).must_equal '31364220-7072-6f6a-6563-742055554944'
      end
    end

    describe '#task_id' do
      it 'returns the task id' do
        _(mess.task_id).must_equal '31364220-7461-736b-2020-202055554944'
      end
    end

    describe '#to_hex' do
      it 'returns a hex representation of the message' do
        assert mess.to_hex.start_with?('44 41 54 41')
        assert mess.to_hex.end_with?('64 61 74 61')
      end
    end

    describe '#to_s' do
      it 'returns the raw bytes' do
        _(mess.to_s).must_equal "#{mess.type}\0\0\0\0\0\0\0\0\0\0\0\0" \
          '16B client  UUID16B project UUID16B task    UUIDsome data'
      end
    end

    describe '#type' do
      it 'returns the message type' do
        _(mess.type).must_match(/\A[A-Z]{4}\z/)
      end
    end
  end
end
