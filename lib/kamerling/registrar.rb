module Kamerling class Registrar
  def register project_uuid: raise, client_uuid: raise, client_addr: raise,
               repos: Repos
    client  = repos[Client][client_uuid]
    project = repos[Project][project_uuid]
    repos[Registration] <<
      Registration[client: client, client_addr: client_addr, project: project]
  end
end end
