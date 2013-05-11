module Kamerling class Registrar
  def register(addrinfo: raise, client: raise, project: raise, repos: nil)
    repos[:registrations] << { addrinfo: addrinfo, client: client, project: project }
  end
end end
