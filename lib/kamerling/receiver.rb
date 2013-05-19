module Kamerling class Receiver
  def receive client_uuid: raise, addr: raise, task_uuid: raise, data: raise,
              repos: Repos.new
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    repos[Result] << Result[client, addr, task, data]
  end
end end
