# frozen_string_literal: true

require 'procto'
require_relative 'result'
require_relative 'settings'

module Kamerling
  class Receiver
    include Procto.call

    def initialize(addr:, message:, settings: Settings.new)
      @addr     = addr
      @message  = message
      @settings = settings
    end

    def call
      client.busy = false
      task.done   = true
      persist
    end

    private

    attr_reader :addr, :message, :settings

    def client
      @client ||= settings.client_repo.fetch(message.client_uuid)
    end

    def persist
      settings.client_repo << client
      settings.result_repo << result
      settings.task_repo << task
    end

    def result
      Result.new(addr: addr, client: client, data: message.payload, task: task)
    end

    def task
      @task ||= settings.task_repo.fetch(message.task_uuid)
    end
  end
end
