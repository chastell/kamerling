module Kamerling class Receiver
  def receive(client: raise, data: raise, repos: nil, task: raise)
    repos[Result] << Result[client, task, data]
  end
end end
