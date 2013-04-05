module Kamerling class Yngo
  Registration = Struct.new :addrinfo, :client, :project

  def register(addrinfo: addrinfo, client: client, project: project,
               repos: nil)
    repos[:registrations] << Registration.new(addrinfo, client, project)
  end
end end
