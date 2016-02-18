# frozen_string_literal: true

require 'sequel'
require_relative 'addr'
require_relative 'repos'
require_relative 'server/http'
require_relative 'server/tcp'
require_relative 'server/udp'
require_relative 'settings'

module Kamerling
  class ServerRunner
    def initialize(args, classes: def_classes, orm: Sequel, repos: Repos)
      settings = Settings.from_args(args)
      repos.db = orm.connect(settings.db)
      @servers = settings.server_addrs.map do |type, addr|
        classes[type].new(addr: addr)
      end
    end

    def join
      servers.each(&:join)
    end

    def start
      servers.each(&:start)
      self
    end

    private

    private_attr_reader :servers

    def def_classes
      { http: Server::HTTP, tcp: Server::TCP, udp: Server::UDP }
    end
  end
end
