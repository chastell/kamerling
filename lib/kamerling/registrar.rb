module Kamerling class Registrar
  def register addr: req(:addr), client_uuid: req(:client_uuid), project_uuid: req(:project_uuid), repos: Repos
    client  = repos[Client][client_uuid]
    project = repos[Project][project_uuid]
    reg     = Registration.new addr: addr, client: client, project: project
    repos[Registration] << reg
  end
end end
