module Kamerling class Receiver
  def receive addr: req(:addr), client_uuid: req(:client_uuid),
              data: req(:data), repos: Repos, task_uuid: req(:task_uuid)
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    result = Result.new addr: addr, client: client, data: data, task: task
    client.busy = false
    task.done   = true
    repos << result << client << task
  end
end end
