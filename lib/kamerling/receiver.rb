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
      repos.record_result addr: addr, client: client, data: message.data,
                          task: task
      repos.client_repo.mark_free(id: client.id)
      repos.task_repo.mark_done(id: task.id)
    end

    private

    attr_reader :addr, :message, :repos

    def client
      @client ||= repos.client_repo.fetch(message.client_id).update(busy: false)
    end

    def task
      @task ||= repos.task_repo.fetch(message.task_id).update(done: true)
    end
  end
end
