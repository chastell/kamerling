module Kamerling class Registrar
  def register(addr: raise, client: raise, project: raise, repos: nil)
    repos[:registrations] << { addr: addr, client: client, project: project }
  end
end end
