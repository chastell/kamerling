module Kamerling class Boso
  Result = Struct.new :client, :task, :data

  def receive(client: client, data: data, repos: repos, task: task)
    repos[:results] << Result.new(client, task, data)
  end
end end
