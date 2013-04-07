module Kamerling class Boso
  def receive(client: client, data: data, repos: repos, task: task)
    repos[:results] << { client: client, data: data, task: task }
  end
end end
