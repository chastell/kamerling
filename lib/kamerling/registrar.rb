module Kamerling class Registrar
  def register addr: raise, client_uuid: raise, project_uuid: raise, repos: {}
    client  = repos[Client][client_uuid]
    project = repos[Project][project_uuid]
    repos[Registration] << Registration[project, client, addr]
  end
end end
