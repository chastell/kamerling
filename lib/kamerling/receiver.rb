require_relative 'client'
require_relative 'repos'
require_relative 'result'
require_relative 'task'

module Kamerling
  class Receiver
    def self.receive(addr:, message:, repos: Repos)
      new(addr: addr, message: message, repos: repos).receive
    end

    def initialize(addr:, message:, repos:)
      @addr    = addr
      @message = message
      @repos   = repos
    end

    def receive
      client.busy = false
      task.done   = true
      repos << result << client << task
    end

    private_attr_reader :addr, :message, :repos

    private

    def client
      @client ||= repos[Client][message.client_uuid]
    end

    def result
      Result.new(addr: addr, client: client, data: message.payload, task: task)
    end

    def task
      @task ||= repos[Task][message.task_uuid]
    end
  end
end
