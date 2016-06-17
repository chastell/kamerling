# frozen_string_literal: true

require_relative 'addr'
require_relative 'value'
require_relative 'server/http'
require_relative 'server/tcp'
require_relative 'server/udp'

module Kamerling
  class Settings < Value
    vals host: String, http: Integer, tcp: Integer, udp: Integer

    def servers
      [
        Server::HTTP.new(addr: Addr[host, http, :TCP]),
        Server::TCP.new(addr:  Addr[host, tcp, :TCP]),
        Server::UDP.new(addr:  Addr[host, udp, :UDP]),
      ].select { |server| server.addr.host and server.addr.port }
    end

    private

    def host
      @host || ENV['HOST']
    end

    def http
      @http || ENV['HTTP']
    end

    def tcp
      @tcp || ENV['TCP']
    end

    def udp
      @udp || ENV['UDP']
    end
  end
end
