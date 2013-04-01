module Kamerling class Yngo
  def register(client: client, project: project, repos: repos)
    repos[:registration].add client: client, project: project
  end
end end
