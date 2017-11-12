require 'procto'
require_relative 'repos'

module Kamerling
  class Receiver
    include Procto.call

    def initialize(addr:, message:, repos: Repos.new)
      @addr    = addr
      @message = message
      @repos   = repos
    end

    def call
      record_result
      update_flags
    end

    private

    attr_reader :addr, :message, :repos

    def client
      @client ||= repos.client_repo.fetch(message.client_id).update(busy: false)
    end

    def record_result
      repos.record_result addr: addr, client: client, data: message.data,
                          task: task
    end

    def task
      @task ||= repos.task_repo.fetch(message.task_id).update(done: true)
    end

    def update_flags
      repos.client_repo.mark_free(id: client.id)
      repos.task_repo.mark_done(id: task.id)
    end
  end
end
