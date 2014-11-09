require_relative 'client'
require_relative 'project'
require_relative 'registration'
require_relative 'repos'
require_relative 'uuid'

module Kamerling
  class Registrar
    def self.register(addr:, message:, repos: Repos)
      new(addr: addr, message: message, repos: repos).register
    end

    def initialize(addr:, message:, repos: Repos)
      @addr, @message, @repos = addr, message, repos
    end

    def register
      client  = find_or_create_client(addr: addr, uuid: message.client_uuid)
      project = repos[Project][message.project_uuid]
      repos << client
      repos << Registration.new(addr: addr, client: client, project: project)
    end

    attr_reader :addr, :message, :repos
    private     :addr, :message, :repos

    private

    def find_or_create_client(addr:, uuid:)
      repos[Client][uuid].tap { |client| client.addr = addr }
    rescue Repo::NotFound
      Client.new(addr: addr, uuid: uuid)
    end
  end
end
