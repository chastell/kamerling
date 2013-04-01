module Kamerling class Boso
  def receive(client: client, data: data, repos: repos, task: task)
    repos[:result] << Result.new(client, task, data)
  end
end end
