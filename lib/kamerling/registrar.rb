module Kamerling class Registrar
  def register addr: raise, client_uuid: raise, project_uuid: raise,
    repos: Repos
    client       = repos[Client][client_uuid]
    project      = repos[Project][project_uuid]
    registration = Registration[addr: addr, client: client, project: project]
    repos[Registration] << registration
  end
end end
