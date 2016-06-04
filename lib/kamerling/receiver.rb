# frozen_string_literal: true

require 'procto'
require_relative 'repos'
require_relative 'result'

module Kamerling
  class Receiver
    include Procto.call

    def initialize(addr:, message:, repos: Repos.new)
      @addr    = addr
      @message = message
      @repos   = repos
    end

    def call
      client.busy = false
      task.done   = true
      persist
    end

    private

    attr_reader :addr, :message, :repos

    def client
      @client ||= repos.client_repo.fetch(message.client_uuid)
    end

    def persist
      repos.client_repo << client
      repos.result_repo << result
      repos.task_repo << task
    end

    def result
      Result.new(addr: addr, client: client, data: message.payload, task: task)
    end

    def task
      @task ||= repos.task_repo.fetch(message.task_uuid)
    end
  end
end
