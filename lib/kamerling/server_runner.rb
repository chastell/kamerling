require 'optparse'
warn_off { require 'sequel' }
require_relative 'addr'
require_relative 'repos'
require_relative 'server/http'
require_relative 'server/tcp'
require_relative 'server/udp'
require_relative 'value'

module Kamerling class ServerRunner
  def initialize args, classes: def_classes, orm: Sequel, repos: Repos
    settings = Settings.new args
    repos.db = orm.connect settings.db
    @servers = { http: :TCP, tcp: :TCP, udp: :UDP }.map do |type, prot|
      addr = Addr[settings.host, settings.send(type), prot]
      classes[type].new addr: addr if addr.port
    end.compact
  end

  def join
    servers.each(&:join)
  end

  def start
    servers.each(&:start)
    self
  end

  attr_reader :servers
  private     :servers

  private

  class Settings < Value
    vals db: String, host: String, http: Integer, tcp: Integer, udp: Integer

    def initialize args
      super db: 'sqlite::memory:', host: '127.0.0.1'
      OptionParser.new do |opt|
        opt.on("--db #{db}", String, 'database') { |db|   self.db   = db   }
        opt.on("--host #{host}", String, 'host') { |host| self.host = host }
        opt.on('--http 0', Integer, 'HTTP port') { |http| self.http = http }
        opt.on('--tcp 0',  Integer, 'TCP port')  { |tcp|  self.tcp  = tcp  }
        opt.on('--udp 0',  Integer, 'UDP port')  { |udp|  self.udp  = udp  }
      end.parse! args
    end
  end

  def def_classes
    { http: Server::HTTP, tcp: Server::TCP, udp: Server::UDP }
  end
end end
