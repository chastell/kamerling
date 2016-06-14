# frozen_string_literal: true

require 'dotenv'
Dotenv.load

require_relative 'addr'
require_relative 'server/http'
require_relative 'server/tcp'
require_relative 'server/udp'

module Kamerling
  class Settings
    def servers
      [
        Server::HTTP.new(addr: Addr[host, http, :TCP]),
        Server::TCP.new(addr:  Addr[host, tcp, :TCP]),
        Server::UDP.new(addr:  Addr[host, udp, :UDP]),
      ].select { |server| server.addr.port }
    end

    private

    def host
      ENV['HOST']
    end

    def http
      ENV['HTTP']
    end

    def tcp
      ENV['TCP']
    end

    def udp
      ENV['UDP']
    end
  end
end
