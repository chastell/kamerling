module Kamerling class Yngo
  def register(addrinfo: addrinfo, client: client, project: project,
               repos: nil)
    repos[:registrations] << { addrinfo: addrinfo, client: client, project: project }
  end
end end
