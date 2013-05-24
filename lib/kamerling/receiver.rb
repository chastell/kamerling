module Kamerling class Receiver
  def receive client_uuid: raise, client_addr: raise, task_uuid: raise,
              data: raise, repos: Repos
    client = repos[Client][client_uuid]
    task   = repos[Task][task_uuid]
    repos[Result] <<
      Result[client: client, client_addr: client_addr, data: data, task: task]
  end
end end
