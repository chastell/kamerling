module Kamerling class Registrar
  def register(addr: raise, client: raise, project: raise, repos: nil)
    repos[Registration] << Registration[project, client, addr]
  end
end end
