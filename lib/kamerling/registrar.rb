require_relative 'client'
require_relative 'project'
require_relative 'registration'
require_relative 'repos'
require_relative 'uuid'

module Kamerling class Registrar
  def initialize repos: Repos
    @repos = repos
  end

  def register addr: req(:addr), message: req(:message), uuid: UUID.new
    client  = repos[Client][message.client_uuid]
    project = repos[Project][message.project_uuid]
    reg     = Registration.new addr: addr, client: client, project: project,
                               uuid: uuid
    repos[Registration] << reg
  end

  attr_reader :repos
  private     :repos
end end
