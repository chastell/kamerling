# frozen_string_literal: true

require 'procto'
require_relative 'client'
require_relative 'project'
require_relative 'registration'
require_relative 'settings'
require_relative 'uuid'

module Kamerling
  class Registrar
    include Procto.call

    def initialize(addr:, message:, settings: Settings.new)
      @addr     = addr
      @message  = message
      @settings = settings
    end

    def call
      client.addr = addr
      settings.client_repo << client
      settings.registration_repo << registration
    end

    private

    attr_reader :addr, :message, :settings

    def client
      @client ||= settings.client_repo.fetch(message.client_uuid) do
        Client.new(addr: addr, uuid: message.client_uuid)
      end
    end

    def project
      @project ||= settings.project_repo.fetch(message.project_uuid)
    end

    def registration
      Registration.new(addr: addr, client: client, project: project)
    end
  end
end
