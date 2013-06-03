module Kamerling class Receiver
  def receive addr: raise, client_uuid: raise, data: raise, repos: Repos,
    task_uuid: raise
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    client.busy = false
    task.done   = true
    repos << Result[addr: addr, client: client, data: data, task: task]
    repos << client
    repos << task
  end
end end
