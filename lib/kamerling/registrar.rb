require_relative 'client'
require_relative 'project'
require_relative 'registration'
require_relative 'repos'

module Kamerling class Registrar
  def initialize repos: Repos
    @repos = repos
  end

  def register addr: req(:addr), client_uuid: req(:client_uuid),
               project_uuid: req(:project_uuid)
    client  = repos[Client][client_uuid]
    project = repos[Project][project_uuid]
    reg     = Registration.new addr: addr, client: client, project: project
    repos[Registration] << reg
  end

  attr_reader :repos
  private     :repos
end end
