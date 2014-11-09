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
      repos << client
      repos << registration
    end

    attr_reader :addr, :message, :repos
    private     :addr, :message, :repos

    private

    def client
      @client ||= find_or_create_client(addr: addr, uuid: message.client_uuid)
    end

    def find_or_create_client(addr:, uuid:)
      repos[Client][uuid].tap { |client| client.addr = addr }
    rescue Repo::NotFound
      Client.new(addr: addr, uuid: uuid)
    end

    def project
      @project ||= repos[Project][message.project_uuid]
    end

    def registration
      Registration.new(addr: addr, client: client, project: project)
    end
  end
end
