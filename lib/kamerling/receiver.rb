module Kamerling class Receiver
  def receive addr: raise, client_uuid: raise, data: raise, repos: Repos,
    task_uuid: raise
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    repos[Result] << Result[addr: addr, client: client, data: data, task: task]
  end
end end
