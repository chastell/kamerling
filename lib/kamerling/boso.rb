module Kamerling class Boso
  def receive(client: client, repos: repos, result: result, task: task)
    repos[:result].add client: client, result: result, task: task
  end
end end
