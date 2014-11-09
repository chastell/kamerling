require_relative 'client'
require_relative 'repos'
require_relative 'result'
require_relative 'task'
require_relative 'uuid'

module Kamerling
  class Receiver
    def self.receive(addr:, message:, repos: Repos, uuid: UUID.new)
      new(addr: addr, message: message, repos: repos, uuid: uuid).receive
    end

    def initialize(addr:, message:, repos:, uuid:)
      @addr, @message, @repos, @uuid = addr, message, repos, uuid
    end

    def receive
      client = repos[Client][message.client_uuid]
      task   = repos[Task][message.task_uuid]
      result = Result.new(addr: addr, client: client, data: message.payload,
                          task: task, uuid: uuid)
      client.busy = false
      task.done   = true
      repos << result << client << task
    end

    attr_reader :addr, :message, :repos, :uuid
    private     :addr, :message, :repos, :uuid
  end
end
