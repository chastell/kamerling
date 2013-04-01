module Kamerling class Yngo
  def register(client: client, project: project, repos: repos)
    repos[:registration] << Registration.new(client, project)
  end
end end
