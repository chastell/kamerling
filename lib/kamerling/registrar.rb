require 'procto'
require_relative 'client'
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
      repos.client_repo << client
      repos.record_registration addr: addr, client: client, project: project
    end

    private

    attr_reader :addr, :message, :repos

    def client
      @client ||= Client.new(addr: addr, id: message.client_id)
    end

    def project
      @project ||= repos.project_repo.fetch(message.project_id)
    end
  end
end
