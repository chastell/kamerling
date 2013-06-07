module Kamerling class Receiver
  def receive addr: raise, client_uuid: raise, data: raise, repos: Repos, task_uuid: raise
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    result = Result[addr: addr, client: client, data: data, task: task]
    client.busy = false
    task.done   = true
    repos << result << client << task
  end
end end
