module Kamerling class Boso
  def receive(client: client, project: project, repos: repos, result: result,
              task: task)
    task.result = result
    repos[:task].update task
  end
end end
