require_relative 'client'
require_relative 'project'
require_relative 'registration'
require_relative 'repos'
require_relative 'uuid'

module Kamerling
  class Registrar
    def initialize repos: Repos
      @repos = repos
    end

    def register addr: req(:addr), message: req(:message), uuid: UUID.new
      client = find_or_create_client addr: addr, uuid: message.client_uuid
      repos[Client] << client
      project = repos[Project][message.project_uuid]
      reg     = Registration.new addr: addr, client: client, project: project,
                                 uuid: uuid
      repos[Registration] << reg
    end

    attr_reader :repos
    private     :repos

    private

    def find_or_create_client addr: req(:addr), uuid: req(:uuid)
      repos[Client][uuid].tap { |client| client.uuid = uuid }
    rescue Repo::NotFound
      Client.new addr: addr, uuid: uuid
    end
  end
end
