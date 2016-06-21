# frozen_string_literal: true

require_relative 'server/http'
require_relative 'server/tcp'
require_relative 'server/udp'

module Kamerling
  class Settings
    def servers
      [Server::HTTP.new, Server::TCP.new, Server::UDP.new].select do |server|
        server.addr.host and server.addr.port
      end
    end
  end
end
