require 'optparse'

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

  Settings = Struct.new(*%i(db host http tcp udp)) do
    def initialize args
      s = defaults
      OptionParser.new do |opt|
        opt.on("--db #{s[:db]}", String, 'database') { |db|   s[:db]   = db   }
        opt.on("--host #{s[:host]}", String, 'host') { |host| s[:host] = host }
        opt.on('--http 0', Integer, 'HTTP port')     { |http| s[:http] = http }
        opt.on('--tcp 0',  Integer, 'TCP port')      { |tcp|  s[:tcp]  = tcp  }
        opt.on('--udp 0',  Integer, 'UDP port')      { |udp|  s[:udp]  = udp  }
      end.parse! args
      super(*self.class.members.map { |key| s[key] })
    end

    private

    def defaults
      { db: 'sqlite::memory:', host: '127.0.0.1' }
    end
  end

  def def_classes
    { http: Server::HTTP, tcp: Server::TCP, udp: Server::UDP }
  end
end end
