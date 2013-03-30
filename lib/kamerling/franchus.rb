module Kamerling class Franchus
  def initialize(client_repo: nil, project_repo: nil, registrar: nil)
    @client_repo  = client_repo
    @project_repo = project_repo
    @registrar    = registrar
  end

  def handle input, scribe: Rainierus.new
    message = scribe.decipher input
    send "handle_#{message.type}", message
  rescue NoMethodError
    raise UnknownMessage, input
  end

  attr_reader :client_repo, :project_repo, :registrar
  private     :client_repo, :project_repo, :registrar

  private

  def handle_RGST message
    client  = client_repo.fetch message.client_uuid
    project = project_repo.fetch message.project_uuid
    registrar.register client, project
  end
end end
