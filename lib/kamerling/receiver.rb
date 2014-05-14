require_relative 'client'
require_relative 'repos'
require_relative 'result'
require_relative 'task'

module Kamerling class Receiver
  def initialize repos: Repos
    @repos = repos
  end

  def receive addr: req(:addr), client_uuid: req(:client_uuid),
              data: req(:data), task_uuid: req(:task_uuid)
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    result = Result.new addr: addr, client: client, data: data, task: task
    client.busy = false
    task.done   = true
    repos << result << client << task
  end

  attr_reader :repos
  private     :repos
end end
