module Kamerling class Registrar
  def register project_uuid: raise, client_uuid: raise, client_addr: raise,
               repos: Repos.new
    client  = repos[Client][client_uuid]
    project = repos[Project][project_uuid]
    repos[Registration] << Registration[project, client, client_addr]
  end
end end
