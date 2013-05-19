module Kamerling class Receiver
  def receive addr: raise, client_uuid: raise, data: raise, repos: {}, task_uuid: raise
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    repos[Result] << Result[client, addr, task, data]
  end
end end
