# frozen_string_literal: true

require_relative 'server/http'
require_relative 'server/tcp'
require_relative 'server/udp'

module Kamerling
  class ServerRunner
    def initialize(servers: default_servers)
      @servers = servers
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

    def default_servers
      [Server::HTTP.new, Server::TCP.new, Server::UDP.new].select do |server|
        server.addr.host and server.addr.port
      end
    end
  end
end
