# frozen_string_literal: true

require 'procto'
require_relative 'client'
require_relative 'project'
require_relative 'registration'
require_relative 'repos'

module Kamerling
  class Registrar
    include Procto.call

    def initialize(addr:, message:, repos: Repos.new)
      @addr    = addr
      @message = message
      @repos   = repos
    end

    def call
      client.addr = addr
      repos.client_repo << client
      repos.registration_repo << registration
    end

    private

    attr_reader :addr, :message, :repos

    def client
      @client ||= repos.client_repo.fetch(message.client_id) do
        Client.new(addr: addr, id: message.client_id)
      end
    end

    def project
      @project ||= repos.project_repo.fetch(message.project_id)
    end

    def registration
      Registration.new(addr: addr, client: client, project: project)
    end
  end
end
