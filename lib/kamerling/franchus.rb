module Kamerling class Franchus
  def initialize(client_repo: nil, project_repo: nil)
    @client_repo  = client_repo
    @project_repo = project_repo
  end

  def handle input, scribe: Rainierus.new
    message = scribe.decipher input
    send "handle_#{message.type}", message
  rescue NoMethodError
    raise UnknownMessage, input
  end

  attr_reader :client_repo, :project_repo
  private     :client_repo, :project_repo

  private

  def handle_RGST message
    client_repo[message.client_uuid] = project_repo[message.project_uuid]
  end
end end
