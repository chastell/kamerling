module Kamerling class Registrar
  def register(addr: raise, client: raise, project: raise, repos: nil)
    repos[Registration] << { addr: addr, client: client, project: project }
  end
end end
