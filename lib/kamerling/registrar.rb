# frozen_string_literal: true

require_relative 'client'
require_relative 'client_repo'
require_relative 'project'
require_relative 'project_repo'
require_relative 'registration'
require_relative 'registration_repo'
require_relative 'uuid'

module Kamerling
  class Registrar
    def self.call(addr:, client_repo: ClientRepo.new, message:,
                  project_repo: ProjectRepo.new,
                  registration_repo: RegistrationRepo.new)
      new(addr: addr, client_repo: client_repo, message: message,
          project_repo: project_repo,
          registration_repo: registration_repo).call
    end

    def initialize(addr:, client_repo:, message:, project_repo:,
                   registration_repo:)
      @addr              = addr
      @client_repo       = client_repo
      @message           = message
      @project_repo      = project_repo
      @registration_repo = registration_repo
    end

    def call
      client.addr = addr
      client_repo << client
      registration_repo << registration
    end

    private

    attr_reader :addr, :client_repo, :message, :project_repo, :registration_repo

    def client
      @client ||= client_repo.fetch(message.client_uuid) do
        Client.new(addr: addr, uuid: message.client_uuid)
      end
    end

    def project
      @project ||= project_repo.fetch(message.project_uuid)
    end

    def registration
      Registration.new(addr: addr, client: client, project: project)
    end
  end
end
