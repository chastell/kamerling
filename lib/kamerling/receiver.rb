module Kamerling class Receiver
  def receive(client: raise, data: raise, repos: nil, task: raise)
    repos[Result] << { client: client, data: data, task: task }
  end
end end
