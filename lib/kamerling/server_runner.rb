# frozen_string_literal: true

require_relative 'settings'

module Kamerling
  class ServerRunner
    def initialize(settings = Settings.new)
      @servers = settings.servers
    end

    def join
      servers.each(&:join)
    end

    def start
      servers.each(&:start)
      self
    end

    private

    attr_reader :servers
  end
end
