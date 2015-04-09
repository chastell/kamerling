require 'equalizer'
require_relative 'uuid'

module Kamerling
  class Message
    KNOWN_TYPES = %i(DATA PING RGST RSLT)
    UnknownType = Class.new(RuntimeError)

    include Equalizer.new(:raw)

    def self.build(client:, payload:, project:, task:, type:)
      new([type, "\0\0\0\0\0\0\0\0\0\0\0\0", UUID.bin(client.uuid),
           UUID.bin(project.uuid), UUID.bin(task.uuid), payload].join)
    end

    def self.data(client:, project:, task:)
      build(client: client, payload: task.data, project: project, task: task,
            type: :DATA)
    end

    def self.parse(raw)
      new(raw)
    end

    def self.rgst(client:, project:)
      build(client: client, payload: '', project: project, task: Task.new,
            type: :RGST)
    end

    def initialize(raw)
      @raw = raw
      fail UnknownType, type unless KNOWN_TYPES.include?(type) or type.empty?
    end

    def client_type
      raw[4..7].to_sym
    end

    def client_uuid
      UUID[raw[16..31]]
    end

    def payload
      raw[64..-1]
    end

    def project_uuid
      UUID[raw[32..47]]
    end

    def task_uuid
      UUID[raw[48..63]]
    end

    def to_hex
      raw.unpack('H*').first.scan(/../).join(' ')
    end

    def to_s
      raw
    end

    def type
      raw[0..3].to_sym
    end

    protected_attr_reader :raw
  end
end
