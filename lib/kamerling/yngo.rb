module Kamerling class Yngo
  Registration = Struct.new :client, :project

  def register(client: client, project: project, repos: repos)
    repos[:registrations] << Registration.new(client, project)
  end
end end
