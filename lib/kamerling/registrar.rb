# frozen_string_literal: true

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

    def initialize(addr:, message:, repos:)
      @addr    = addr
      @message = message
      @repos   = repos
    end

    def register
      client.addr = addr
      repos.client_repo << client
      repos.registration_repo << registration
    end

    private

    attr_reader :addr, :message, :repos

    def client
      @client ||= repos.client_repo.fetch(message.client_uuid) do
        Client.new(addr: addr, uuid: message.client_uuid)
      end
    end

    def project
      @project ||= repos.project_repo.fetch(message.project_uuid)
    end

    def registration
      Registration.new(addr: addr, client: client, project: project)
    end
  end
end
