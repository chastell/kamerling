# frozen_string_literal: true

require 'procto'
require_relative 'client_repo'
require_relative 'result'
require_relative 'result_repo'
require_relative 'task_repo'

module Kamerling
  class Receiver
    include Procto.call
    def initialize(addr:, client_repo: ClientRepo.new, message:,
                   result_repo: ResultRepo.new, task_repo: TaskRepo.new)
      @addr        = addr
      @client_repo = client_repo
      @message     = message
      @result_repo = result_repo
      @task_repo   = task_repo
    end

    def call
      client.busy = false
      task.done   = true
      persist
    end

    private

    attr_reader :addr, :client_repo, :message, :result_repo, :task_repo

    def client
      @client ||= client_repo.fetch(message.client_uuid)
    end

    def persist
      client_repo << client
      result_repo << result
      task_repo << task
    end

    def result
      Result.new(addr: addr, client: client, data: message.payload, task: task)
    end

    def task
      @task ||= task_repo.fetch(message.task_uuid)
    end
  end
end
