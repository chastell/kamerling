module Kamerling class Franchus
  def initialize(registrar: nil, repos: nil)
    @repos     = repos
    @registrar = registrar
  end

  def handle input, scribe: Rainierus.new
    message = scribe.decipher input
    send "handle_#{message.type}", message
  rescue NoMethodError
    raise UnknownMessage, input
  end

  attr_reader :registrar, :repos
  private     :registrar, :repos

  private

  def handle_RGST message
    client  = repos.fetch(:client).fetch message.client_uuid
    project = repos.fetch(:project).fetch message.project_uuid
    registrar.register client, project
  end
end end
