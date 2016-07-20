# frozen_string_literal: true

require 'equalizer'
require_relative 'uuid'

module Kamerling
  class Message
    KNOWN_TYPES = %i(DATA PING RGST RSLT).freeze
    UnknownType = Class.new(RuntimeError)

    include Equalizer.new(:raw)

    def self.build(client:, data: '', project:, task: Task.null, type:)
      new([type, "\0\0\0\0\0\0\0\0\0\0\0\0", UUID.bin(client.id),
           UUID.bin(project.id), UUID.bin(task.id), data].join)
    end

    def self.data(client:, project:, task:)
      build(client: client, data: task.data, project: project, task: task,
            type: :DATA)
    end

    def self.rgst(client:, project:)
      build(client: client, project: project, type: :RGST)
    end

    def self.rslt(client:, data:, task:)
      build(client: client, data: data, project: task.project, task: task,
            type: :RSLT)
    end

    def initialize(raw)
      @raw = raw
      raise UnknownType, type unless KNOWN_TYPES.include?(type)
    end

    def client_type
      raw[4..7].to_sym
    end

    def client_id
      UUID[raw[16..31]]
    end

    def data
      raw[64..-1]
    end

    def project_id
      UUID[raw[32..47]]
    end

    def task_id
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

    protected

    attr_reader :raw
  end
end
